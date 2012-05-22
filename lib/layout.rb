module Teacup
  # Teacup::Layout defines a layout function that can be used to configure the
  # layout of views in your application.
  #
  # It is included into UIView and UIViewController directly so these functions
  # should be available when you need them.
  #
  # In order to use layout() in a UIViewController most effectively you will want
  # to create a stylesheet method
  module Layout
    def style_sheet
      nil
    end

    def restyle!
      top_level_view.style_sheet = style_sheet
    end

    def layout(class_or_instance, name_or_properties, properties_or_nil=nil, &block)
      instance = Class === class_or_instance ? class_or_instance.new : class_or_instance

      if Class === class_or_instance
        unless class_or_instance <= UIView
          raise "Expected subclass of UIView, got: #{class_or_instance.inspect}"
        end
        instance = class_or_instance.new
      elsif UIView === class_or_instance
        instance = class_or_instance
      else
        raise "Expected a UIView, got: #{class_or_instance.inspect}"
      end

      if properties_or_nil
        name = name_or_properties.to_sym
        properties = properties_or_nil
      elsif Hash === name_or_properties
        name = nil
        properties = name_or_properties
      else
        name = name_or_properties.to_sym
        properties = nil
      end

      instance.style_sheet = style_sheet
      instance.style(properties) if properties
      instance.style_name = name if name

      if !instance.superview && !(instance == top_level_view)
        (superview_chain.last || top_level_view).addSubview(instance)
      end
      begin
        superview_chain << instance
        instance_exec(instance, &block) if block_given?
      ensure
        superview_chain.pop
      end

      instance
    end

    def top_level_view
      case self
      when UIViewController
        view
      when UIView
        self
      end
    end

    def superview_chain
      @superview_chain ||= []
    end
  end
end
