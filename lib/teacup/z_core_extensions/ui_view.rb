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

      new_constraints = add_unig_constraints(properties.delete(:constraints))

      self.setTranslatesAutoresizingMaskIntoConstraints(false) unless new_constraints.empty?
      new_constraints.each do |constraint|
        constraint_copy = constraint.copy
        window = UIApplication.sharedApplication.keyWindow

        case constraint.target
        when :self
          constraint_copy.target = self
        when :superview
          constraint_copy.target = self.superview
        when Symbol, String
          container = self
          while container.superview
            container = container.superview
          end
          constraint_copy.target = container.viewWithStylename(constraint.target)
        end

        case constraint.relative_to
        when :self
          constraint_copy.relative_to = self
        when :superview
          constraint_copy.relative_to = self.superview
        when Symbol, String
          container = self
          while container.superview
            container = container.superview
          end
          constraint_copy.relative_to = container.viewWithStylename(constraint.relative_to)
        end

        if constraint_copy.target.isDescendantOfView(constraint_copy.relative_to)
          constraint_copy.relative_to.addConstraint(constraint_copy.nslayoutconstraint)
        elsif constraint_copy.relative_to.isDescendantOfView(constraint_copy.target)
          constraint_copy.target.addConstraint(constraint_copy.nslayoutconstraint)
        else
          parent = constraint_copy.relative_to.superview
          while parent
            if constraint_copy.target.isDescendantOfView(parent)
              parent.addConstraint(constraint_copy.nslayoutconstraint)
              parent = nil
            elsif parent.superview
              parent = parent.superview
            else
              raise "The two views #{constraint.target} and #{constraint.relative_to} do not have a common ancestor"
            end
          end
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

  def add_unig_constraints(constraint)
    @constrain_just_once ||= {}

    if constraint.is_a? Array
      constraint.map{|constraint| add_unig_constraints(constraint) }.flatten
    elsif constraint.is_a? Hash
      constraint.select{|sym, relative_to|
        @constrain_just_once[sym].nil?
      }.map{|sym, relative_to|
        @constrain_just_once[sym] = true
        Teacup::Constraint.from_sym(sym, relative_to)
      }
    else
      if @constrain_just_once[constraint]
        []
      else
        @constrain_just_once[constraint] = true
        if constraint.is_a? Symbol
          [Teacup::Constraint.from_sym(constraint)]
        else
          [constraint]
        end
      end
    end
  end

end
