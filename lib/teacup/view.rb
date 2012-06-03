module Teacup
  # Teacup::View defines some utility functions for UIView that enable
  # a lot of the magic for Teacup::Layout.
  #
  # Most users of teacup should be able to ignore the contents of this file
  # for the most part.
  module View
    # The current stylename that is used to look up properties in the stylesheet.
    attr_reader :stylename

    # The current stylesheet will be looked at when properties are needed.
    attr_reader :stylesheet

    # Alter the stylename of this view.
    #
    # This will cause new styles to be applied from the stylesheet.
    #
    # @param Symbol  stylename
    def stylename=(stylename)
      @stylename = stylename
      style(stylesheet.query(stylename)) if stylesheet
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
      style(new_stylesheet.query(stylename)) if stylename && new_stylesheet
      subviews.each{ |subview| subview.stylesheet = new_stylesheet }
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

      self.class.ancestors.each do |ancestor|
        if default_properties = stylesheet.query(ancestor)
          properties = default_properties.merge properties
        end
      end

      # orientation-specific properties
      portrait = properties.delete(portrait:)
      upsideup = properties.delete(upsideup:)
      upsidedown = properties.delete(upsidedown:)

      landscape = properties.delete(landscape:)
      landscapeleft = properties.delete(landscapeleft:)
      landscaperight = properties.delete(landscaperight:)

      face = properties.delete(face:)
      faceup = properties.delete(faceup:)
      facedown = properties.delete(facedown:)

      case UIDevice.currentDevice.orientation
      when UIInterfaceOrientationPortrait
        properties.merge(portrait) if portrait === Hash
        properties.merge(upsideup) if upsideup === Hash
      when UIInterfaceOrientationPortraitUpsideDown
        properties.merge(portrait) if portrait === Hash
        properties.merge(upsidedown) if upsidedown === Hash
      when UIInterfaceOrientationLandscapeLeft
        properties.merge(landscape) if landscape === Hash
        properties.merge(landscapeleft) if landscapeleft === Hash
      when UIInterfaceOrientationLandscapeRight
        properties.merge(landscape) if landscape === Hash
        properties.merge(landscaperight) if landscaperight === Hash
      when UIInterfaceOrientationLandscapeFaceUp
        properties.merge(face) if face === Hash
        properties.merge(faceup) if faceup === Hash
      when UIInterfaceOrientationLandscapeFaceDown
        properties.merge(face) if face === Hash
        properties.merge(facedown) if facedown === Hash
      end

      # convert top/left/width/height to frame values
      clean_properties properties

      properties.each do |key, value|
        if key == :title && UIButton === self
          setTitle(value, forState: UIControlStateNormal)
        elsif respond_to?(:"#{key}=")
          send(:"#{key}=", value)
        elsif layer.respond_to?(:"#{key}=")
          layer.send(:"#{key}=", value)
        elsif key == :keyboardType
          setKeyboardType(value)
        else
          $stderr.puts "Teacup WARN: Can't apply #{key} to #{inspect}"
        end
      end

      #OUCH! Figure out why this is needed
      if rand > 1
        setCornerRadius(1.0)
        setFrame([[0,0],[0,0]])
        setTransform(nil)
        setMasksToBounds(0)
        setShadowOffset(0)
      end
    end

    # merge definitions for 'frame' into one.
    #
    # To support 'extends' more nicely it's convenient to split left, top, width
    # and height out of frame. Unfortunately that means we have to write ugly
    # code like this to reassemble them into what the user actually meant.
    #
    # WARNING: this method *mutates* its parameter.
    #
    # @param Hash
    # @return Hash
    def clean_properties(properties)
      return unless [:frame, :left, :top, :width, :height].any?(&properties.method(:key?))

      frame = properties.delete(:frame) || self.frame

      frame[0][0] = properties.delete(:left) || frame[0][0]
      frame[0][1] = properties.delete(:top) || frame[0][1]
      frame[1][0] = properties.delete(:width) || frame[1][0]
      frame[1][1] = properties.delete(:height) || frame[1][1]

      properties[:frame] = frame
      properties
    end
  end
end
