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
    #     layout :my_view do
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
    def layout(stylename=nil, properties={}, &block)
      @layout_definition = [stylename, properties, block]
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
    #   stylesheet = Teacup::Stylesheet[:ipadhorizontal]
    #   stylesheet = :ipadhorizontal
    def stylesheet=(new_stylesheet)
      super
      if self.viewLoaded?
        self.view.restyle!
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
        stylename, properties, block = layout_definition
        layout(top_level_view, stylename, properties, &block)
      end

      layoutDidLoad

      if should_restyle
        Teacup.should_restyle!
        self.top_level_view.restyle!
      end

      if defined? NSLayoutConstraint
        self.top_level_view.apply_constraints
      end
    end

    def layoutDidLoad
    end

  end

end
