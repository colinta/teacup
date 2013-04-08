class PresentModalController < UIViewController
  attr :modal

  stylesheet :present_modal

  layout :root do
    @button = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :open_modal_button)
    @button.addTarget(self, action: :open_modal_button, forControlEvents:UIControlEventTouchUpInside)
  end

  def open_modal_button
    @modal = ConstraintsController.new
    self.presentViewController(@modal, animated:true, completion:nil)
  end

end


Teacup::Stylesheet.new :present_modal do

  style :root,
    backgroundColor: UIColor.blackColor

  style :open_modal_button,
    title: 'Open Modal',
    constraints: [
      :centered
    ]

end
