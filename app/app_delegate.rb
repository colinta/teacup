class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    application.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationSlide)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    ctlr = ConstraintsController.new
    @window.rootViewController = ctlr
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

end
