
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
  #     layout(:my_view) do
  #       layout UIImage, :logo
  #     end
  #
  #     def stylesheet
  #       Teacup::Stylesheet[:logo]
  #     end
  #   end
  module Layout
    attr_accessor :stylesheet

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
    #   layout(carousel) {
    #     subview(UIImage, backgroundColor: UIColor.colorWithImagePattern(image)
    #   }
    #
    def layout(view, name_or_properties=nil, properties_or_nil=nil, &block)
      name = nil
      properties = properties_or_nil

      if Hash === name_or_properties
        name = nil
        properties = name_or_properties
      elsif name_or_properties
        name = name_or_properties.to_sym
      end

      view.stylesheet = stylesheet
      view.stylename = name
      view.style(properties) if properties

      begin
        superview_chain << view
        instance_exec(view, &block) if block_given?
      ensure
        superview_chain.pop
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
    #     heirarchy(:my_view) do
    #       subview(UILabel, text: 'Test')
    #       subview(UILabel, :styled_label)
    #     end
    #   end
    #
    # If you need to add a new image at runtime, you can also do that:
    #
    # @example
    #   layout(carousel) {
    #     subview(UIImage, backgroundColor: UIColor.colorWithImagePattern(image)
    #   }
    #
    def subview(class_or_instance, *args, &block)
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

      (superview_chain.last || top_level_view).addSubview(instance)

      layout(instance, *args, &block)

      instance
    end

    protected

    # Get's the current stack of views in nested calls to layout.
    #
    # The view at the end of the stack is the one into which subviews
    # are currently being attached.
    def superview_chain
      @superview_chain ||= []
    end
  end
end
