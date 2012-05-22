module Teacup
  module View
    attr_reader :style_name, :style_sheet

    def style_name=(style_name)
      @style_name = style_name
      style(style_sheet.query(style_name)) if style_sheet
    end

    def style_sheet=(style_sheet)
      @style_sheet = style_sheet
      style(style_sheet.query(style_name)) if style_name && style_sheet
      subviews.each{ |subview| subview.style_sheet = style_sheet }
    end

    def animate_to_style_name(style_name, options={})
      return if self.style_name == style_name
      UIView.beginAnimations(nil, context: nil)
      # TODO: This should be in a style-sheet!
      UIView.setAnimationDuration(options[:duration]) if options[:duration]
      UIView.setAnimationCurve(options[:curve]) if options[:curve]
      self.style_name = style_name
      UIView.commitAnimations
    end

    def style(properties)
      clean_properties! properties

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

    def clean_properties!(properties)
      return unless [:frame, :left, :top, :width, :height].any?(&properties.method(:key?))

      frame = properties.delete(:frame) || self.frame

      frame[0][0] = properties.delete(:left) || frame[0][0]
      frame[0][1] = properties.delete(:top) || frame[0][1]
      frame[1][0] = properties.delete(:width) || frame[1][0]
      frame[1][1] = properties.delete(:height) || frame[1][1]

      properties[:frame] = frame
    end
  end
end
