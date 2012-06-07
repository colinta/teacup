class HaiViewController < UIViewController
end

class MyHaiViewController < HaiViewController
  stylesheet :iphone

  layout :hai do
    subview(UILabel, :label)
    subview(UILabel, :footer)
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end

class MCTableViewController < UITableViewController
  stylesheet :main
end