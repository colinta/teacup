
class LandscapeOnlyController < UIViewController

  def viewDidLoad
    UIApplication.sharedApplication.windows[0].rootViewController = FirstController.alloc.init
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation == UIDeviceOrientationLandscapeLeft or orientation == UIDeviceOrientationLandscapeRight
      true
    else
      false
    end
  end

end