class HaiViewController < UIViewController

  stylesheet :iphone

  layout :hai do
    subview(UILabel, :label)
    subview(UILabel, :footer)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end
