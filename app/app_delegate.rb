class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.setStatusBarStyle(UIStatusBarStyleBlackTranslucent)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = FirstController.new
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

end
