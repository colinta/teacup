
class LandscapeOnlyController < UIViewController

  def viewDidLoad
    UIApplication.sharedApplication.windows[0].rootViewController = FirstController.alloc.init
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation == UIInterfaceOrientationLandscapeLeft or orientation == UIInterfaceOrientationLandscapeRight
      true
    else
      false
    end
  end

end