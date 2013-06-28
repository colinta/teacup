class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    application.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationSlide)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # change this controller to whatever controller you want to test, or are
    # writing tests for.
    ctlr = TableViewController.new
    @window.rootViewController = ctlr
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

end
