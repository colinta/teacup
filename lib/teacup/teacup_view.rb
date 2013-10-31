# Teacup's View extensions defines some utility functions for View that enable a
# lot of the magic for Teacup::Layout.
#
# Users of teacup should be able to ignore the contents of this file for
# the most part.
module Teacup
  module View

    # The current stylename that is used to look up properties in the stylesheet.
    attr_reader :stylename

    # A list of style classes that will be merged in (lower priority than stylename)
    attr_reader :style_classes

    # Any class that includes Teacup::Layout gets a `layout` method, which assigns
    # itself as the 'teacup_next_responder'.
    attr_accessor :teacup_next_responder

    # Enable debug messages for this object
    attr_accessor :debug

    # Subviews or empty collection of views to cater for issue with iOS7 dp3
    def teacup_subviews
      subviews || []
    end


    # Alter the stylename of this view.
    #
    # This will cause new styles to be applied from the stylesheet.
    #
    # If you are using Pixate, it will also set the pixate `styleId` property.
    #
    # @param Symbol  stylename
    def stylename=(new_stylename)
      @stylename = new_stylename
      if respond_to?(:'setStyleId:')
        setStyleId(new_stylename)
      end
      if respond_to?(:'setNuiClass:')
        setNuiClass(new_stylename)
      end
      restyle!
    end

    # Why stop at just one stylename!?  Assign a bunch of them using
    # `style_classes`. These are distinct from `stylename`, and `stylename` styles
    # are given priority of `style_classes`.
    #
    # If you are using Pixate, it will also set the pixate `styleClass` property.
    #
    # @param Array [Symbol] style_classes
    def style_classes=(new_style_classes)
      @style_classes = new_style_classes
      if respond_to?(:setStyleClass)
        setStyleClass(new_style_classes.join(' '))
      end
      restyle!
    end

    def style_classes
      @style_classes ||= []
    end

    def add_style_class(stylename)
      unless style_classes.include? stylename
        style_classes << stylename
        restyle!
      end
    end

    def remove_style_class(stylename)
      if style_classes.delete(stylename)
        restyle!
      end
    end

    # Alter the stylesheet of this view.
    #
    # This will cause new styles to be applied using the current stylename,
    # and will recurse into subviews.
    #
    # If you would prefer that a given UIView object does not inherit the
    # stylesheet from its parents, override the 'stylesheet' method to
    # return the correct value at all times.
    #
    # @param Teacup::Stylesheet  stylesheet.
    def stylesheet=(new_stylesheet)
      should_restyle = Teacup.should_restyle_and_block

      @stylesheet = new_stylesheet

      if should_restyle
        Teacup.should_restyle!
        restyle!
      end
    end

    def stylesheet
      if @stylesheet.is_a? Symbol
        @stylesheet = Teacup::Stylesheet[@stylesheet]
      end
      # is a stylesheet assigned explicitly?
      retval = @stylesheet
      return retval if retval

      # the 'teacup_next_responder' is assigned in the `layout` method, and links
      # any views created there to the custom class (could be a controller, could
      # be any class that includes Teacup::Layout).  That responder is checked
      # next, but only if it wouldn't result in a circular loop.
      if ! retval && @teacup_next_responder && teacup_next_responder != self
        retval = @teacup_next_responder.stylesheet
      end

      # lastly, go up the chain; either a controller or superview
      if ! retval && nextResponder && nextResponder.respond_to?(:stylesheet)
        retval = nextResponder.stylesheet
      end

      return retval
    end

    def restyle!(orientation=nil)
      if Teacup.should_restyle?
        if stylesheet && stylesheet.is_a?(Teacup::Stylesheet)
          style_classes.each do |stylename|
            style(stylesheet.query(stylename, self, orientation))
          end
          style(stylesheet.query(self.stylename, self, orientation))
        end
        teacup_subviews.each { |subview| subview.restyle!(orientation) }
      end
    end

    def get_ns_constraints
      # gets the array of Teacup::Constraint objects
      my_constraints = (@teacup_constraints || []).map { |constraint, relative_to|
        if constraint.is_a?(Teacup::Constraint)
          constraint
        else
          if relative_to == true
            Teacup::Constraint.from_sym(constraint)
          else
            Teacup::Constraint.from_sym(constraint, relative_to)
          end
        end
      }.flatten.map do |original_constraint|
        constraint = original_constraint.copy

        view_class = self.class

        case original_constraint.target
        when view_class
          constraint.target = original_constraint.target
        when :self
          constraint.target = self
        when :superview
          constraint.target = self.superview
        when Symbol, String
          container = self
          constraint.target = nil
          while container && constraint.target.nil?
            constraint.target = container.viewWithStylename(original_constraint.target)
            container = container.superview
          end
        end

        case original_constraint.relative_to
        when nil
          constraint.relative_to = nil
        when view_class
          constraint.relative_to = original_constraint.relative_to
        when :self
          constraint.relative_to = self
        when :superview
          constraint.relative_to = self.superview
        when :top_layout_guide 
          if controller.respondsToSelector(:topLayoutGuide)
            constraint.relative_to = controller.topLayoutGuide
          else
            puts "topLayoutGuide is only supported in >= iOS 7. Reverting to nil bound"
            constraint.relative_to = nil
          end
        when :bottom_layout_guide
          if controller.respondsToSelector(:bottomLayoutGuide)
            constraint.relative_to = controller.bottomLayoutGuide
          else
            puts "bottomLayoutGuide is only supported in >= iOS 7. Reverting to nil bound"
            constraint.relative_to = nil
          end 
        when Symbol, String
          # TODO: this re-checks lots of views - everytime it goes up to the
          # superview, it checks all the leaves again.
          container = self
          constraint.relative_to = nil
          while container && constraint.relative_to.nil?
            constraint.relative_to = container.viewWithStylename(original_constraint.relative_to)
            container = container.superview
          end
        end

        if original_constraint.relative_to && ! constraint.relative_to
          container = self
          tab = ''
          while container
            tab << '->'
            puts "#{tab} #{container.stylename.inspect}"
            container = container.superview
          end
          raise "Could not find #{original_constraint.relative_to.inspect}"
        end

        # the return value, for the map
        constraint.nslayoutconstraint
      end

      unless my_constraints.empty?
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
      end

      # now add all che child constraints
      teacup_subviews.each do |subview|
        my_constraints.concat(subview.get_ns_constraints)
      end

      my_constraints
    end

    def apply_constraints
      if @teacup_added_constraints
        @teacup_added_constraints.each do |constraint|
          self.removeConstraint(constraint)
        end
      end
      @teacup_added_constraints = nil
      all_constraints = get_ns_constraints

      return if all_constraints.empty?

      @teacup_added_constraints = []
      all_constraints.each do |ns_constraint|
        @teacup_added_constraints << ns_constraint
        self.addConstraint(ns_constraint)
      end
    end

    # Applies styles pulled from a stylesheet, but does not assign those styles to
    # any property.  This is a one-shot use method, meant to be used as
    # initialization or to apply styles that should not be reapplied during a
    # rotation.
    def apply_stylename(stylename)
      if stylesheet && stylesheet.is_a?(Teacup::Stylesheet)
        style(stylesheet.query(stylename, self))
      end
    end

    # Animate a change to a new stylename.
    #
    # This is equivalent to wrapping a call to .stylename= inside
    # UIView.beginAnimations.
    #
    # @param Symbol  the new stylename
    # @param Options  the options for the animation (may include the
    #                 duration and the curve)
    #
    def animate_to_stylename(stylename, options={})
      return if self.stylename == stylename

      teacup_animation(options) do
        self.stylename = stylename
      end
    end

    # Animate a change to a new list of style_classes.
    #
    # This is equivalent to wrapping a call to .style_classes= inside
    # UIView.beginAnimations.
    #
    # @param Symbol  the new stylename
    # @param Options  the options for the animation (may include the
    #                 duration and the curve)
    #
    def animate_to_styles(style_classes, options={})
      return if self.style_classes == style_classes

      teacup_animation(options) do
        self.style_classes = style_classes
      end
    end

    # Animate a change to new styles
    #
    # This is equivalent to wrapping a call to .style() inside
    # UIView.beginAnimations.
    #
    # @param Hash   the new styles and options for the animation
    #
    def animate_to_style(style)
      teacup_animation(options) do
        self.style(style)
      end
    end

    # Apply style properties to this element.
    #
    # Takes a hash of properties such as may have been read from a stylesheet
    # or passed as parameters to {Teacup::Layout#layout}, and applies them to
    # the element.
    #
    # Does a little bit of magic (that may be split out as 'sugarcube') to
    # make properties work as you'd expect.
    #
    # If you try and assign something in properties that is not supported,
    # a warning message will be emitted.
    #
    # @param Hash  the properties to set.
    def style(properties)
      apply_style_properties(properties)
    end

    def apply_style_properties(properties)
      Teacup.apply_hash self, properties
    end

    def reset_constraints
      @teacup_constraints = nil
      subviews.each do |subview|
        subview.reset_constraints
      end
    end

    def add_uniq_constraints(constraint)
      @teacup_constraints ||= {}

      if constraint.is_a? Array
        constraint.each do |constraint|
          add_uniq_constraints(constraint)
        end
      elsif constraint.is_a? Hash
        constraint.each do |sym, relative_to|
          @teacup_constraints[sym] = relative_to
        end
      elsif constraint.is_a?(Teacup::Constraint) || constraint.is_a?(Symbol)
        @teacup_constraints[constraint] = true
      else
        raise "Unsupported constraint: #{constraint.inspect}"
      end
    end

    # helper method to resolve the view's controller
    def controller
      if nextResponder && nextResponder.is_a?(UIViewController)
        nextResponder
      elsif nextResponder
        nextResponder.controller
      else
        nil
      end
    end

  end
end
