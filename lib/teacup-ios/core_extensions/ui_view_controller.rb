class UIViewController
  include Teacup::Layout
  include Teacup::Controller

  def viewDidLoad
    teacupDidLoad
  end

  # This method *used* to be useful for the `shouldAutorotateToOrientation`
  # method, but the iOS 6 update deprecates that method.  Instead, use the
  # `supportedInterfaceOrientations` and return `autorotateMask`.
  def autorotateToOrientation(orientation)
    device = UIDevice.currentDevice.userInterfaceIdiom
    if view.stylesheet and view.stylesheet.is_a?(Teacup::Stylesheet) and view.stylename
      properties = view.stylesheet.query(view.stylename, self, orientation)

      # check for orientation-specific properties
      case orientation
      when UIInterfaceOrientationPortrait
        # portrait is "on" by default, must be turned off explicitly
        if properties.supports?(:portrait) == nil and properties.supports?(:upside_up) == nil
          return true
        end

        return (properties.supports?(:portrait) or properties.supports?(:upside_up))
      when UIInterfaceOrientationPortraitUpsideDown
        if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
          # iphone must have an explicit upside-down style, otherwise this returns
          # false
          return properties.supports?(:upside_down)
        else
          # ipad can just have a portrait style
          return (properties.supports?(:portrait) or properties.supports?(:upside_down))
        end
      when UIInterfaceOrientationLandscapeLeft
        return (properties.supports?(:landscape) or properties.supports?(:landscape_left))
      when UIInterfaceOrientationLandscapeRight
        return (properties.supports?(:landscape) or properties.supports?(:landscape_right))
      end

      return false
    end

    # returns the system default
    if device == UIUserInterfaceIdiomPhone
      return orientation != UIInterfaceOrientationPortraitUpsideDown
    else
      return true
    end
  end

  # You can use this method in `supportedInterfaceOrientations`, and it will
  # query the stylesheet for the supported orientations, based on what
  # orientations are defined.  At a minimum, to opt-in to this feature, you'll
  # need to define styles like `style :root, landscape: true`
  def autorotateMask
    device = UIDevice.currentDevice.userInterfaceIdiom
    if view.stylesheet and view.stylesheet.is_a?(Teacup::Stylesheet) and view.stylename
      properties = view.stylesheet.query(view.stylename, self, orientation)

      orientations = 0
      if properties.supports?(:portrait) or properties.supports?(:upside_up)
        orientations |= UIInterfaceOrientationPortrait
      end

      if device == UIUserInterfaceIdiomPhone
        # :portrait does not imply upside_down on the iphone
        if properties.supports?(:upside_down)
          orientations |= UIInterfaceOrientationPortraitUpsideDown
        end
      else
        # but does on the ipad
        if properties.supports?(:portrait) or properties.supports?(:upside_down)
          orientations |= UIInterfaceOrientationPortraitUpsideDown
        end
      end

      if properties.supports?(:landscape) or properties.supports?(:landscape_left)
        orientations |= UIInterfaceOrientationLandscapeLeft
      end

      if properties.supports?(:landscape) or properties.supports?(:landscape_right)
        orientations |= UIInterfaceOrientationLandscapeRight
      end

      if orientations == 0
        orientations |= UIInterfaceOrientationPortrait
      end
      return orientations
    end

    # returns the system default
    if device == UIUserInterfaceIdiomPhone
      return UIInterfaceOrientationMaskAllButUpsideDown
    else
      return UIInterfaceOrientationMaskAll
    end
  end

  # restyles the view!  be careful about putting styles in your stylesheet that
  # you change in your controller.  anything that might change over time should
  # be applied in your controller using `style`
  def willAnimateRotationToInterfaceOrientation(orientation, duration:duration)
    view.restyle!(orientation)
  end

  def top_level_view
    view
  end

end
