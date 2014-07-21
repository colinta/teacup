# Adds methods to the UIViewController/NSViewController/NSWindowController
# classes to make defining a layout and stylesheet very easy.  Also provides
# rotation methods that analyze
module Teacup
  module ControllerClass

    attr_reader :layout_definition

    # Define the layout of a controller's view.
    #
    # This function is analogous to Teacup::Layout#layout, though it is
    # designed so you can create an entire layout in a declarative manner in
    # your controller.
    #
    # The hope is that this declarativeness will allow us to automatically
    # deal with common iOS programming tasks (like releasing views when
    # low-memory conditions occur) for you. This is still not implemented
    # though.
    #
    # @param name  The stylename for your controller's view.
    #
    # @param properties  Any extra styles that you want to apply.
    #
    # @param &block  The block in which you should define your layout.
    #                It will be instance_exec'd in the context of a
    #                controller instance.
    #
    # @example
    #   class MyViewController < UIViewController
    #     def teacup_layout
    #       root :my_view
    #       subview UILabel, title: "Test"
    #       subview UITextField, {
    #         frame: [[200, 200], [100, 100]]
    #         delegate: self
    #       }
    #       subview(UIView, :shiny_thing) {
    #         subview UIView, :centre_of_shiny_thing
    #       }
    #     end
    #   end
    #
    def layout(stylename=nil, properties={})
      if block_given?
        msg = <<-MSG
Time to update your syntax!

It was discovered that passing a block to the Controller##layout was causing
irreparable memory leaks.  The only recourse is to use a new syntax and remove
the old functionality.

If you need to assign a stylename to the root view, you can still do this using
`layout :stylename`, but you cannot pass a block to this class method any
longer.

Instead, define a method called `teacup_layout` and create your views there.  No
other changes are required.
MSG
        raise msg
      end
      @layout_definition = [stylename, properties]
    end

  end

  module Controller
    def self.included(base)
      base.extend ControllerClass
    end

    # Assigning a new stylesheet triggers {restyle!}.
    #
    # Assigning a stylesheet is an *alternative* to returning a Stylesheet in
    # the {stylesheet} method. Note that {restyle!} calls {stylesheet}, so while
    # assigning a stylesheet will trigger {restyle!}, your stylesheet will not
    # be picked up if you don't return it in a custom stylesheet method.
    #
    # @return Teacup::Stylesheet
    #
    # @example
    #
    #   stylesheet = Teacup::Stylesheet[:main]
    #   stylesheet = :main
    def stylesheet=(new_stylesheet)
      super
      if self.viewLoaded?
        self.view.restyle!
      end
    end

    def root(stylename=nil, properties={})
      if stylename.is_a?(NSDictionary)
        properties = stylename
        stylename = nil
      end

      if stylename || properties
        layout(top_level_view, stylename, properties)
      else
        top_level_view
      end
    end

    # Instantiate the layout from the class, and then call layoutDidLoad.
    #
    # If you want to use Teacup in your controller, please hook into layoutDidLoad,
    # not viewDidLoad or windowDidLoad (they call this method).
    def teacupDidLoad
      # look for a layout_definition in the list of ancestors
      layout_definition = nil
      my_stylesheet = self.stylesheet
      parent_class = self.class
      while parent_class != NSObject and not (layout_definition && my_stylesheet)
        if not my_stylesheet and parent_class.respond_to?(:stylesheet)
          my_stylesheet = parent_class.stylesheet
        end

        if not layout_definition and parent_class.respond_to?(:layout_definition)
          layout_definition = parent_class.layout_definition
        end
        parent_class = parent_class.superclass
      end

      should_restyle = Teacup.should_restyle_and_block

      if my_stylesheet and not self.stylesheet
        self.stylesheet = my_stylesheet
      end

      if layout_definition
        stylename, properties = layout_definition
        layout(top_level_view, stylename, properties)
      end

      if respond_to?(:teacup_layout)
        teacup_layout
      end

      layoutDidLoad

      if should_restyle
        Teacup.should_restyle!
        self.top_level_view.restyle!
      end

      if defined?(NSLayoutConstraint)
        self.top_level_view.apply_constraints
      end
    end

    def layoutDidLoad
    end

  end

end
