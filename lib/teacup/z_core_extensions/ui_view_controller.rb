class UIViewController
  include Teacup::Layout

  class << self
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
    #   MyViewController < UIViewController
    #     layout :my_view do
    #       subview UILabel, title: "Test"
    #       subview UITextField, {
    #         frame: [[200, 200], [100, 100]]
    #         delegate: self
    #       }
    #       subview UIView, :shiny_thing) {
    #         subview UIView, :centre_of_shiny_thing
    #       }
    #     end
    #   end
    #
    def layout(stylename, properties={}, &block)
      @layout_definition = [stylename, properties, block]
    end

    # Retreive the layout defined by {layout}
    def layout_definition
      @layout_definition
    end
  end

  # Instantiate the layout from the class, and then call layoutDidLoad.
  #
  # If you want to use Teacup in your controller, please hook into layoutDidLoad,
  # not viewDidLoad.
  def viewDidLoad
    if self.class.layout_definition
      name, properties, block = self.class.layout_definition
      layout(view, name, properties, &block)
    end

    layoutDidLoad
  end

  def layoutDidLoad
    true
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if view.stylesheet && view.stylename
      properties = view.stylesheet.query(view.stylename)

      # check for orientation-specific properties
      case orientation
      when UIInterfaceOrientationPortrait
        return true if (properties[portrait:] or properties[upsideup:])
        return false
      when UIInterfaceOrientationPortraitUpsideDown
        return true if (properties[portrait:] or properties[upsidedown:])
        return false
      when UIInterfaceOrientationLandscapeLeft
        return true if (properties[landscape:] or properties[landscapeleft:])
        return false
      when UIInterfaceOrientationLandscapeRight
        return true if (properties[landscape:] or properties[landscaperight:])
        return false
      when UIInterfaceOrientationLandscapeFaceUp
        return true if (properties[face:] or properties[faceup:])
        return false
      when UIInterfaceOrientationLandscapeFaceDown
        return true if (properties[face:] or properties[facedown:])
        return false
      end
    end

    super
  end

end
