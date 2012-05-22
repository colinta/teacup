module Teacup
  # Teacup::Layout defines a layout function that can be used to configure the
  # layout of views in your application.
  #
  # It is included into UIView and UIViewController directly so these functions
  # should be available when you need them.
  #
  # In order to use layout() in a UIViewController most effectively you will want
  # to define a stylesheet method that returns a stylesheet.
  #
  # @example
  #   class MyViewController < UIViewController
  #     interface(:my_view) do
  #       layout UIImage, :logo
  #     end
  #  
  #     def stylesheet
  #       Teacup::Stylesheet::Logo
  #     end
  #   end
  #
  module Layout

    # Define or alter the layout for a view.
    #
    # @param class_or_instance  The first parameter is the view that you want to
    #                           layout. Though for convenience you can also pass
    #                           a UIView subclass and a new view will be created
    #                           for you.
    #
    #                           If a new view is created, or the passed view is
    #                           not yet present in the view heirarchy it will be
    #                           added at the current level. (see &block)
    #
    # @param name               The second parameter is optional, and is the
    #                           stylename to apply to the element. When using
    #                           stylesheets any properties defined in the
    #                           current stylesheet (see {stylesheet}) for this
    #                           element will be immediately applied.
    #
    # @param properties         The third parameter is optional, and is a Hash
    #                           of properties to apply to the view directly.
    #
    # @param &block             If a block is passed, it is evaluated such that
    #                           any calls to {layout} that occur within that
    #                           block cause created subviews to be added to *this*
    #                           view instead of to the top-level view.
    #
    # For example, when creating a layout in the interface block of a
    # constructor, you might want to add several labels:
    # 
    # @example
    #   interface(:my_view_controller) do
    #     layout(UILabel, :left_label, text: "One")
    #     layout(UILabel, :left_label, text: "Two")
    #   end
    #
    # You might also need to create nested structures in order to get perfect
    # view effects:
    # 
    # @example
    #   interface(:my_view_controller) do
    #     layout(UIView, :shiny_thing) {
    #       layout(UIView, :glow) {
    #         layout(UIView, :star)
    #       }
    #       layout(UIView, :moon)
    #     }
    #   end
    #
    # Use of the layout function is not restricted to defining interfaces
    # though, it can also be used to alter existing views.
    #
    # For example, to add a new image to a carousel:
    #
    # @example
    #   layout(carousel) {
    #     layout(UIImage, backgroundColor: UIColor.colorWithImagePattern(image)
    #   }
    #
    # Or to modify the properties of an element:
    # 
    # @example
    #   layout(carousel, width: 500, height: 100)
    #
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

      instance.stylesheet = stylesheet
      instance.style(properties) if properties
      instance.stylename = name if name

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

    # Returns a stylesheet to use to style the contents of this controller's
    # view.
    #
    # This method will be queried each time {restyle!} is called, and also
    # implicitly # whenever Teacup needs to draw your layout (currently only at
    # view load time).
    #
    # @return Teacup::Stylesheet
    #
    # @example
    #
    #  def stylesheet
    #    if [UIDeviceOrientationLandscapeLeft,
    #        UIDeviceOrientationLandscapeRight].include?(UIDevice.currentDevice.orientation)
    #      Teacup::Stylesheet::IPad
    #    else
    #      Teacup::Stylesheet::IPadVertical
    #    end
    #  end
    def stylesheet
      nil
    end

    # Instruct teacup to reapply styles to your subviews
    #
    # You should call this whenever the return value of your stylesheet meethod
    # would change,
    #
    # @example
    #   def willRotateToInterfaceOrientation(io, duration: duration)
    #     restyle!
    #   end
    def restyle!
      top_level_view.stylesheet = stylesheet
    end

    protected

    # Get's the top-level UIView for this object.
    #
    # This can either be 'self' if the current object is in fact a UIView,
    # or 'view' if it's a controller.
    #
    # @return UIView
    def top_level_view
      case self
      when UIViewController
        view
      when UIView
        self
      end
    end

    # Get's the current stack of views in nested calls to layout.
    #
    # The view at the end of the stack is the one into which subviews
    # are currently being attached.
    def superview_chain
      @superview_chain ||= []
    end
  end
end
