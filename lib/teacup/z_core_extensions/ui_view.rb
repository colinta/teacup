# Teacup's UIView extensions defines some utility functions for UIView that
# enable a lot of the magic for Teacup::Layout.

# Users of teacup should be able to ignore the contents of this file for
# the most part.
class UIView
  include Teacup::Layout

  # The current stylename that is used to look up properties in the stylesheet.
  attr_reader :stylename

  # The current stylesheet will be looked at when properties are needed.  It
  # is loaded lazily, so that assignment can occur before the Stylesheet has
  # been created.
  def stylesheet
    if Symbol === @stylesheet
      @stylesheet = Teacup::Stylesheet[@stylesheet]
    end

    @stylesheet
  end

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
    @stylesheet = new_stylesheet
    restyle!
    subviews.each{ |subview| subview.stylesheet = new_stylesheet }
  end

  def restyle!(orientation=nil)
    style(stylesheet.query(stylename, self, orientation)) if stylesheet
    subviews.each{ |subview| subview.restyle!(orientation) }
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
    if layer_properties = properties.delete(:layer)
      layer_properties.each do |key, value|
        assign = :"#{key}="
        setter = ('set' + key.to_s.sub(/^./) {|c| c.capitalize}).to_sym
        if layer.respond_to?(assign)
          # NSLog "Setting layer.#{key} = #{value.inspect}"
          layer.send(assign, value)
        elsif layer.respond_to?(setter)
          # NSLog "Calling layer(#{key}, #{value.inspect})"
          layer.send(setter, value)
      else
        NSLog "Teacup WARN: Can't apply #{key} to #{self.layer.inspect}"
        end
      end
    end

    properties.each do |key, value|
      if key =~ /^set[A-Z]/
        assign = nil
        setter = key.to_s + ':'
      else
        assign = :"#{key}="
        setter = 'set' + key.to_s.sub(/^./) {|c| c.capitalize} + ':'
      end

      if key == :title && UIButton === self
        # NSLog "Setting #{key} = #{value.inspect}, forState:UIControlStateNormal"
        setTitle(value, forState: UIControlStateNormal)
      # elsif key == :normal && UIButton === self
      #   setImage(value, forState: UIControlStateNormal)
      # elsif key == :highlighted && UIButton === self
      #   setImage(value, forState: UIControlStateHighlighted)
      elsif assign and respond_to?(assign)
        # NSLog "Setting #{key} = #{value.inspect}"
        send(assign, value)
      elsif respondsToSelector(setter)
        # NSLog "Calling self(#{key}, #{value.inspect})"
        send(setter, value)
      else
        NSLog "Teacup WARN: Can't apply #{setter.inspect}#{assign and " or " + assign.inspect or ""} to #{self.inspect}"
      end
    end
    self.setNeedsDisplay
  end

  def top_level_view
    return self
  end

end
