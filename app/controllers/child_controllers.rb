class RootViewController < UIViewController
  attr :child_controller
  stylesheet :root_screen

  def viewDidLoad
    @child_controller = ChildViewController.new
    self.addChildViewController(@child_controller)

    layout(self.view, :root) do
      subview(@child_controller.view, frame: [[0, 100], [320, 100]])
    end
  end
end


class ChildViewController < UIViewController
  stylesheet :child_screen

  def viewDidLoad
    super

    layout(self.view, :detail)
  end
end


Teacup::Stylesheet.new :root_screen do

  style :root,
    backgroundColor: UIColor.blueColor

  style :detail,
    backgroundColor: UIColor.greenColor

end


Teacup::Stylesheet.new :child_screen do

  style :detail,
    backgroundColor: UIColor.yellowColor

end
