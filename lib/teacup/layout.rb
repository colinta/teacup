module Teacup
  # Adds the class `stylesheet` method to
  module LayoutClass

    # Calling this method in the class body will assign a default stylesheet for
    # all instances of your class
    def stylesheet(new_stylesheet=nil)
      if new_stylesheet.nil?
        if @stylesheet.is_a? Symbol
          @stylesheet = Teacup::Stylesheet[@stylesheet]
        end

        return @stylesheet
      end

      @stylesheet = new_stylesheet
    end

  end

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
    def self.included(base)
      base.extend LayoutClass
    end

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

      @stylesheet || self.class.stylesheet
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
    # @param classes            The third parameter is optional, and is a list
    #                           of style classes.
    #
    # @param properties         The fourth parameter is optional, and is a Hash
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
    def layout(view_or_class, *teacup_settings, &block)
      view = Teacup.to_instance(view_or_class)

      # prevents the calling of restyle! until we return to this method
      should_restyle = Teacup.should_restyle_and_block

      teacup_style = Style.new

      teacup_settings.each do |setting|
        case setting
        when Symbol, String
          view.stylename = setting
        when Hash
          # override settings, but apply them to teacup_style so that it remains
          # a Teacup::Style object
          Teacup::merge_defaults(setting, teacup_style, teacup_style)
        when Enumerable
          view.style_classes = setting
        when nil
          # skip. this is so that helper methods that accept arguments like
          # stylename can pass those on to this method without having to
          # introspect the values (just set the default value to `nil`)
          #
          # long story short: tests will fail `nil` is not ignore here
        else
          raise "The argument #{setting.inspect} is not supported in Teacup::Layout::layout()"
        end
      end

      if view.is_a? Teacup::View
        view.style(teacup_style.build(view))
      else
        Teacup.apply_hash view, teacup_style.build(view)
      end

      # assign the 'teacup_next_responder', which is queried for a stylesheet if
      # one is not explicitly assigned to the view
      if view.is_a? Layout
        view.teacup_next_responder = WeakRef.new(self)
        # view.teacup_next_responder = self
      end

      if block_given?
        superview_chain << view
        begin
          # yield will not work if this is defined in the context of the
          # UIViewController `layout` class method.
          instance_exec(view, &block)
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
      instance = Teacup.to_instance(class_or_instance)

      (superview_chain.last || top_level_view).addSubview(instance)

      layout(instance, *args, &block)

      instance
    end

    ##|
    ##|  Motion-Layout support
    ##|

    # Calling this method uses Nick Quaranto's motion-layout gem to provide ASCII
    # art style access to autolayout.  It assigns all the subviews by stylename,
    # and assigns `self.view` as the target view.  Beyond that, it's up to you to
    # implement the layout methods:
    #
    #     auto do
    #       metrics 'margin' => 20
    #       vertical "|-[top]-margin-[bottom]-|"
    #       horizontal "|-margin-[top]-margin-|"
    #       horizontal "|-margin-[bottom]-margin-|"
    #     end
    def auto(layout_view=top_level_view, layout_subviews={}, &layout_block)
      raise "gem install 'motion-layout'" unless defined? Motion::Layout

      styled_subviews = top_level_view.subviews.select { |v| v.stylename }
      styled_subviews.each do |view|
        if ! layout_subviews[view.stylename.to_s]
          layout_subviews[view.stylename.to_s] = view
        end
      end

      Motion::Layout.new do |layout|
        layout.view layout_view
        layout.subviews layout_subviews
        layout.instance_eval(&layout_block)
      end
    end

    def top_level_view
      raise "No default view has been defined for #{self.class}.  Implement `top_level_view`."
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
