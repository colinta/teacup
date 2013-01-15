module Teacup
  # Teacup::Layout defines a layout and subview function that can be used to
  # declare and configure the layout of views and the view hierarchy in your
  # application.
  #
  # This module is included into UIView and UIViewController directly so these
  # functions are available in the places you need them.
  #
  # In order to use layout() in a UIViewController most effectively you will want
  # to define a stylesheet method that returns a stylesheet.
  #
  # @example
  #   class MyViewController < UIViewController
  #     stylesheet :logo
  #
  #     layout(:my_view) do
  #       layout UIImage, :logo
  #     end
  #   end
  module Layout
    # Assign a Stylesheet or Stylesheet name (Symbol)
    #
    # @return val
    #
    # @example
    #
    #   stylesheet = Stylesheet.new do
    #                  style :root, backgroundColor: UIColor.blueColor
    #                end
    #   controller.stylesheet = stylesheet
    #   # or use a stylename
    #   view.stylesheet = :stylesheet_name
    #
    def stylesheet= val
      @stylesheet = val
    end

    # Returns a stylesheet to use to style the contents of this controller's
    # view.  You can also assign a stylesheet to {stylesheet=}, which will in
    # turn call {restyle!}.
    #
    # This method will be queried each time {restyle!} is called, and also
    # implicitly whenever Teacup needs to draw your layout (currently only at
    # view load time).
    #
    # @return Teacup::Stylesheet
    #
    # @example
    #
    #  def stylesheet
    #    if [UIInterfaceOrientationLandscapeLeft,
    #        UIInterfaceOrientationLandscapeRight].include?(UIInterface.currentDevice.orientation)
    #      Teacup::Stylesheet[:ipad]
    #    else
    #      Teacup::Stylesheet[:ipadvertical]
    #    end
    #  end
    def stylesheet
      if @stylesheet.is_a? Symbol
        @stylesheet = Teacup::Stylesheet[@stylesheet]
      end

      @stylesheet
    end

    # Alter the layout of a view
    #
    # @param instance           The first parameter is the view that you want to
    #                           layout.
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
    #                           any calls to {subview} that occur within that
    #                           block cause created subviews to be added to *this*
    #                           view instead of to the top-level view.
    #
    # For example, to alter the width and height of a carousel:
    #
    # @example
    #   layout(carousel, width: 500, height: 100)
    #
    # Or to layout the carousel in the default style:
    #
    # @example
    #   layout(carousel, :default_carousel)
    #
    # You can also use this method with {subview}, for example to add a new
    # image to a carousel:
    #
    # @example
    #   layout(carousel) do
    #     subview(UIImage, backgroundColor: UIColor.colorWithImagePattern(image)
    #   end
    #
    def layout(view_or_class, name_or_properties=nil, properties_or_nil=nil, &block)
      view = to_instance(view_or_class)

      name = nil
      properties = properties_or_nil

      if name_or_properties.is_a? Hash
        name = nil
        properties = name_or_properties
      elsif name_or_properties
        name = name_or_properties.to_sym
      end

      # prevents the calling of restyle! until we return to this method
      should_restyle = Teacup.should_restyle_and_block

      unless view.stylesheet
        view.stylesheet = stylesheet
      end
      view.stylename = name
      if properties
        view.style(properties) if properties
      end

      if block_given?
        superview_chain << view
        begin
          instance_exec(view, &block) if block_given?
        rescue NoMethodError => e
          NSLog("Exception executing layout(#{view.inspect}) in #{self.inspect} (stylesheet=#{stylesheet})")
          raise e
        end

        superview_chain.pop
      end

      if should_restyle
        Teacup.should_restyle!
        view.restyle!
      end
      view
    end

    # Add a new subview to the view heirarchy.
    #
    # By default the subview will be added at the top level of the view heirarchy, though
    # if this function is executed within a block passed to {layout} or {subview}, then this
    # view will be added as a subview of the instance being layed out by the block.
    #
    # This is particularly useful when coupled with the {UIViewController.heirarchy} function
    # that allows you to declare your view heirarchy.
    #
    # @param class_or_instance  The UIView subclass (or instance thereof) that you want
    #                           to add. If you pass a class, an instance will be created
    #                           by calling {new}.
    #
    # @param *args              Arguments to pass to {layout} to instruct teacup how to
    #                           lay out the newly added subview.
    #
    # @param &block             A block to execute with the current view context set to
    #                           your new element, see {layout} for more details.
    #
    # @return instance          The instance that was added to the view heirarchy.
    #
    # For example, to specify that a controller should contain some labels:
    #
    # @example
    #   MyViewController < UIViewController
    #     layout(:my_view) do
    #       subview(UILabel, text: 'Test')
    #       subview(UILabel, :styled_label)
    #     end
    #   end
    #
    # If you need to add a new image at runtime, you can also do that:
    #
    # @example
    #   layout(carousel) do
    #     subview(UIImage, backgroundColor: UIColor.colorWithImagePattern(image)
    #   end
    #
    def subview(class_or_instance, *args, &block)
      instance = to_instance(class_or_instance)

      (superview_chain.last || top_level_view).addSubview(instance)

      layout(instance, *args, &block)

      instance
    end

    protected

    def to_instance(class_or_instance)
      if class_or_instance.is_a? Class
        unless class_or_instance <= UIView
          raise "Expected subclass of UIView, got: #{class_or_instance.inspect}"
        end
        return class_or_instance.new
      elsif class_or_instance.is_a?(UIView)
        return class_or_instance
      else
        raise "Expected a UIView, got: #{class_or_instance.inspect}"
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
