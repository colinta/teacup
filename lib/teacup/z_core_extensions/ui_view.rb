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
  def style(properties, orientation=nil)
    teacup_apply_hash self, properties
    properties.each do |key, value|
      teacup_apply self, key, value
    end

    self.setNeedsDisplay
    self.setNeedsLayout
  end

  # applies a Hash of styles, and converts the frame styles (origin, size, top,
  # left, width, height) into one frame property.
  def teacup_apply_hash(target, properties)
    properties.each do |key, value|
      teacup_apply target, key, value
    end
  end

  # Applies a single style to a target.  Delegates to a teacup_handler if one is
  # found.
  def teacup_apply(target, key, value)
    # note about `debug`: not all objects in this method are a UIView instance,
    # so don't assume that the object *has* a debug method.

    target.class.ancestors.each do |ancestor|
      if ancestor.respond_to? :teacup_handlers and ancestor.teacup_handlers.has_key? key
        NSLog "#{ancestor.name} is Handling #{key} = #{value.inspect}" if target.respond_to? :debug and target.debug
        ancestor.teacup_handlers[key].call(target, value)
        return
      end
    end

    # you can send methods to subviews (e.g. UIButton#titleLabel) and CALayers
    # (e.g. UIView#layer) by assigning a hash to a style name.
    if Hash === value
      return teacup_apply_hash target.send(key), value
    end

    if key =~ /^set[A-Z]/
      assign = nil
      setter = key.to_s + ':'
    else
      assign = :"#{key}="
      setter = 'set' + key.to_s.sub(/^./) {|c| c.capitalize} + ':'
    end

    if key == :title && UIButton === target
      NSLog "Setting #{key} = #{value.inspect}, forState:UIControlStateNormal" if target.respond_to? :debug and target.debug
      target.setTitle(value, forState: UIControlStateNormal)
    elsif assign and target.respond_to?(assign)
      NSLog "Setting #{key} = #{value.inspect}" if target.respond_to? :debug and target.debug
      target.send(assign, value)
    elsif target.respondsToSelector(setter)
      NSLog "Calling target(#{key}, #{value.inspect})" if target.respond_to? :debug and target.debug
      target.send(setter, value)
    else
      NSLog "Teacup WARN: Can't apply #{setter.inspect}#{assign and " or " + assign.inspect or ""} to #{target.inspect}"
    end
  end

  def top_level_view
    return self
  end

end
