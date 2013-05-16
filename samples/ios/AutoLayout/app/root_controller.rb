class RootController < UIViewController
  stylesheet :root

  layout :root do
    @label = subview(UILabel, :label)
    @button = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :button)
    @switch = subview(UISwitch, :switch)
  end  

  def viewDidLoad
  	super
  	# Title for this view
  	self.title = "Autolayout Example"
  end

end
