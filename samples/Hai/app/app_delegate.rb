class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = HaiViewController.alloc.init.tap{ |c|
      c.wantsFullScreenLayout = true
    }
    @window.makeKeyAndVisible
  
    true
  end
end
