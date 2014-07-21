class HaiViewController < UIViewController
  stylesheet :iphone

  def teacup_layout
    root :hai
    @a = subview(UILabel, :label)
    @b = subview(UILabel, :footer)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end
