class HaiViewController < UIViewController
  stylesheet :iphone

  layout :hai do
    @a = subview(UILabel, :label)
    @b = subview(UILabel, :footer)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end
