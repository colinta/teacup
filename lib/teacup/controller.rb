
module Teacup

  # Teacup::Controller defines methods that allow a hierarchy to be build using
  # a class method `layout`, which is loaded in `viewDidLoad`.  This gives a
  # kind of "nib-ability" to UIViewControllers.
  #
  # @example
  #   class MyViewController < UIViewController
  #     include Teacup::Controller
  #
  #     stylesheet :my_view
  #     layout do
  #       subview(UILabel, :header)
  #       subview(UILabel, :footer)
  #     end
  #   end
  #
  module Controller

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
    #    if [UIDeviceOrientationLandscapeLeft,
    #        UIDeviceOrientationLandscapeRight].include?(UIDevice.currentDevice.orientation)
    #      Teacup::Stylesheet[:ipad]
    #    else
    #      Teacup::Stylesheet[:ipadvertical]
    #    end
    #  end
    def stylesheet
      @stylesheet
    end

    # Assigning a new stylesheet triggers {restyle!}, so do this during a
    # rotation to get your different layouts applied.
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
    def stylesheet=(new_stylesheet)
      @stylesheet = new_stylesheet
      view.stylesheet = new_stylesheet
      view.restyle!
    end

    def top_level_view
      return self.view
    end


    # Instantiate the layout from the class, and then call layoutDidLoad.
    #
    # If you want to use Teacup in your controller, please hook into layoutDidLoad,
    # not viewDidLoad.
    def viewDidLoad

      if not self.stylesheet
        self.stylesheet = self.class.stylesheet
      end

      if self.class.layout_definition
        stylename, properties, block = self.class.layout_definition
        layout(view, stylename, properties, &block)
      end

      layoutDidLoad
    end

    def viewWillAppear(animated)
      self.view.restyle!
    end

    def layoutDidLoad
      true
    end

  end

end
