class PresentModalController < UIViewController

  stylesheet :present_modal

  layout :root do
    @button = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :open_modal_button)
    @button.addTarget(self, action: :open_modal_button, forControlEvents:UIControlEventTouchUpInside)
  end

  def open_modal_button
    self.presentViewController(PresentedController.new, animated:true, completion:nil)
  end

end

class PresentedController < UIViewController

  stylesheet :present_modal

  layout :root do
    subview(UIView, :header)
    subview(UIView, :footer)
    subview(UIView, :center) do
      $left = subview(UIView, :left)
      $top_right = subview(UIView, :top_right)
      $btm_right = subview(UIView, :btm_right)
    end
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

  style :header,
    backgroundColor: UIColor.blueColor,
    constraints: [
      :full_width,
      :top,
      constrain_height(52),
    ]

  style :footer,
    backgroundColor: UIColor.magentaColor,
    constraints: [
      :full_width,
      :bottom,
      constrain_height(52),
    ]

  style :center,
    backgroundColor: UIColor.lightGrayColor,
    constraints: [
      constrain_below(:header).plus(8),
      constrain_above(:footer).minus(8),
      constrain_left(8),
      constrain_right(-8),
    ]

  style :left,
    backgroundColor: UIColor.redColor,
    constraints: [
      constrain_left(8),
      constrain_top(8),
      constrain(:right).plus(8).equals(:top_right, :left),
      constrain(:right).plus(8).equals(:btm_right, :left),
      constrain_bottom(-8),
      constrain(:width).equals(:top_right, :width),
      constrain(:width).equals(:btm_right, :width),
    ]

  style :top_right,
    backgroundColor: UIColor.greenColor,
    constraints: [
      constrain(:top).equals(:left, :top),
      constrain_right(-8),
      constrain(:height).equals(:btm_right, :height),
      constrain(:bottom).plus(8).equals(:btm_right, :top),
    ]

  style :btm_right,
    backgroundColor: UIColor.yellowColor,
    constraints: [
      constrain(:bottom).equals(:left, :bottom),
    ]

end
