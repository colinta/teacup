class TeacupViewController < UIViewController
  include Teacup::Layout
  include Teacup::Controller

  class << self
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
    def layout(stylename=nil, properties={}, &block)
      stylename = :'__root__' if not stylename

      @layout_definition = [stylename, properties, block]
    end

    def stylesheet(new_stylesheet=nil)
      if new_stylesheet.nil?
        return @stylesheet
      end

      @stylesheet = new_stylesheet
    end

  end # class << self

  def shouldAutorotateToInterfaceOrientation(orientation)
    if view.stylesheet
      properties = view.stylesheet.query(view.stylename)

      # check for orientation-specific properties
      case orientation
      when UIInterfaceOrientationPortrait
        return true if (properties[:portrait] or properties[:upside_up])
      when UIInterfaceOrientationPortraitUpsideDown
        if UIDevice.currentDevice.userInterfaceIdiom == :iphone.uidevice
          # iphone must have an explicit upside-down style, otherwise this returns
          # false
          return true if properties[:upside_down]
        else
          # ipad can just have a portrait style
          return true if (properties[:portrait] or properties[:upside_down])
        end
      when UIInterfaceOrientationLandscapeLeft
        return true if (properties[:landscape] or properties[:landscape_left])
      when UIInterfaceOrientationLandscapeRight
        return true if (properties[:landscape] or properties[:landscape_right])
      end
      return false
    end

    return orientation == UIInterfaceOrientationPortrait
  end

  def willAnimateRotationToInterfaceOrientation(orientation, duration:duration)
    view.restyle!(orientation)
  end

end