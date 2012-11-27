# Teacup's UIView extensions defines some utility functions for UIView that
# enable a lot of the magic for Teacup::Layout.

# Users of teacup should be able to ignore the contents of this file for
# the most part.
class UIView
  include Teacup::Layout

  # The current stylename that is used to look up properties in the stylesheet.
  attr_reader :stylename

  # Enable debug messages for this object
  attr_accessor :debug

  # Alter the stylename of this view.
  #
  # This will cause new styles to be applied from the stylesheet.
  #
  # @param Symbol  stylename
  def stylename=(new_stylename)
    @stylename = new_stylename
    restyle! if Teacup.should_restyle?
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
    subviews.each{ |subview| subview.set_stylesheet_quickly(new_stylesheet) }

    if should_restyle
      Teacup.should_restyle!
      restyle!
    end
  end

  def set_stylesheet_quickly(new_stylesheet)
    @stylesheet = new_stylesheet
    subviews.each{ |subview| subview.set_stylesheet_quickly(new_stylesheet) }
  end

  def restyle!(orientation=nil)
    if Teacup.should_restyle?
      resetTeacupConstraints

      if stylesheet && stylesheet.is_a?(Teacup::Stylesheet)
        style(stylesheet.query(stylename, self, orientation))
      end
      subviews.each{ |subview| subview.restyle!(orientation) }
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

    UIView.beginAnimations(nil, context: nil)
    # TODO: This should be in a style-sheet!
    UIView.setAnimationDuration(options[:duration]) if options[:duration]
    UIView.setAnimationCurve(options[:curve]) if options[:curve]
    self.stylename = stylename
    UIView.commitAnimations
  end

  # Animate a change to new styles
  #
  # This is equivalent to wrapping a call to .style() inside
  # UIView.beginAnimations.
  #
  # @param Hash   the new styles and options for the animation
  #
  def animate_to_style(style)
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(style[:duration]) if style[:duration]
    UIView.setAnimationCurve(style[:curve]) if style[:curve]
    style(style)
    UIView.commitAnimations
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
  def style(properties, orientation=nil)
    if properties.key?(:constraints)
      new_constraints = add_uniq_constraints(properties.delete(:constraints))

      self.setTranslatesAutoresizingMaskIntoConstraints(false) unless new_constraints.empty?

      @teacup_added_constraints ||= []
      new_constraints.each do |original_constraint|
        constraint = original_constraint.copy

        case original_constraint.target
        when :self
          constraint.target = self
        when :superview
          constraint.target = self.superview
        when Symbol, String
          container = self
          constraint.target = nil
          while container.superview && constraint.target == nil
            constraint.target = container.viewWithStylename(original_constraint.target)
            container = container.superview
          end
        end

        case original_constraint.relative_to
        when :self
          constraint.relative_to = self
        when :superview
          constraint.relative_to = self.superview
        when Symbol, String
          # TODO: this re-checks lots of views - everytime it goes up to the
          # superview, it checks all the leaves again.
          container = self
          constraint.relative_to = nil
          while container.superview && constraint.relative_to == nil
            constraint.relative_to = container.viewWithStylename(original_constraint.relative_to)
            container = container.superview
          end
        end

        add_constraint_to = nil
        if constraint.target == constraint.relative_to || constraint.relative_to.nil?
          add_constraint_to = constraint.target.superview
        elsif constraint.target.isDescendantOfView(constraint.relative_to)
          add_constraint_to = constraint.relative_to
        elsif constraint.relative_to.isDescendantOfView(constraint.target)
          add_constraint_to = constraint.target
        else
          parent = constraint.relative_to.superview
          while parent
            if constraint.target.isDescendantOfView(parent)
              add_constraint_to = parent
              parent = nil
            elsif parent.superview
              parent = parent.superview
            end
          end
        end

        if add_constraint_to
          ns_constraint = constraint.nslayoutconstraint

          @teacup_added_constraints << { target: add_constraint_to, constraint: ns_constraint }
          add_constraint_to.addConstraint(ns_constraint)
        else
          raise "The two views #{original_constraint.target} and #{original_constraint.relative_to} do not have a common ancestor"
        end
      end
    end

    Teacup.apply_hash self, properties

    self.setNeedsDisplay
    self.setNeedsLayout
  end

  def top_level_view
    return self
  end

  def teacup_added_constraints ; @teacup_added_constraints ; end

  def resetTeacupConstraints
    if @teacup_added_constraints
      @teacup_added_constraints.each do |added_constraint|
        target = added_constraint[:target]
        constraint = added_constraint[:constraint]
        target.removeConstraint(constraint)
      end
    end
    @teacup_added_constraints = nil
    @teacup_constrain_just_once = nil
  end

  def add_uniq_constraints(constraint)
    @teacup_constrain_just_once ||= {}

    if constraint.is_a? Array
      new_consraints = constraint.map{|constraint| add_uniq_constraints(constraint) }.flatten
    elsif constraint.is_a? Hash
      new_consraints = constraint.select{|sym, relative_to|
        @teacup_constrain_just_once[sym].nil?
      }.map{|sym, relative_to|
        @teacup_constrain_just_once[sym] = true
        Teacup::Constraint.from_sym(sym, relative_to)
      }
    else
      if @teacup_constrain_just_once[constraint]
        new_consraints = []
      else
        @teacup_constrain_just_once[constraint] = true
        if constraint.is_a? Symbol
          new_consraints = [Teacup::Constraint.from_sym(constraint)]
        else
          new_consraints = [constraint]
        end
      end
    end

    return new_consraints
  end

end
