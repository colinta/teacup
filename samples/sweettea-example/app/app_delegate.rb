include SugarCube::Adjust

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    ctlr = MyController.new
    first = UINavigationController.alloc.initWithRootViewController(ctlr)
    @window.rootViewController = first
    @window.makeKeyAndVisible

    true
  end
end


Teacup::Stylesheet.new(:teacup) do
  style :label,
    color: :white,
    background: :clear,
    constraints: [
      :center_x,
      :center_y,
    ]

  style :button,
    title: 'neat.',
    constraints: [
      :center_x,
      constrain_below(:label).plus(0),
    ]

end


class MyController < UIViewController
  stylesheet :teacup

  layout do
    @label = subview(UILabel, :label, text: 'nifty?')
    @button = subview(UIButton.rounded, :button)
  end

end
