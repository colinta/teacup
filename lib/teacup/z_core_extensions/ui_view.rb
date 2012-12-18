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
    restyle!
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
      if stylesheet && stylesheet.is_a?(Teacup::Stylesheet)
        style(stylesheet.query(stylename, self, orientation))
      end
      subviews.each{ |subview| subview.restyle!(orientation) }
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
    }.flatten.tap{ |my_constraints|
      unless my_constraints.empty?
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
      end
    }.map do |original_constraint|
      constraint = original_constraint.copy

      case original_constraint.target
      when UIView
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
      when UIView
        constraint.relative_to = original_constraint.relative_to
      when :self
        constraint.relative_to = self
      when :superview
        constraint.relative_to = self.superview
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

      unless constraint.relative_to
        puts "Could not find #{original_constraint.relative_to}"
        container = self
        tab = '  '
        while container && constraint.relative_to.nil?
          tab << '->'
          puts "#{tab} #{container.stylename.inspect}"
          container = container.superview
        end
      end

      # the return value, for the map
      constraint.nslayoutconstraint
    end

    # now add all che child constraints
    subviews.each do |subview|
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
    UIView.setAnimationDelay(options[:delay]) if options[:delay]
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
    UIView.setAnimationDelay(options[:delay]) if options[:delay]
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
      add_uniq_constraints(properties.delete(:constraints))
    end

    Teacup.apply_hash self, properties

    self.setNeedsDisplay
    self.setNeedsLayout
  end

  def top_level_view
    return self
  end

  def add_uniq_constraints(constraint)
    @teacup_constraints ||= {}

    if constraint.is_a? Array
      constraint.each { |constraint|
        add_uniq_constraints(constraint)
      }
    elsif constraint.is_a? Hash
      constraint.each { |sym, relative_to|
        @teacup_constraints[sym] = relative_to
      }
    elsif constraint.is_a? Teacup::Constraint or constraint.is_a? Symbol
      @teacup_constraints[constraint] = true
    else
      raise "Unsupported constraint: #{constraint.inspect}"
    end
  end

end
