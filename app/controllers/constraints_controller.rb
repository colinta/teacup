class ConstraintsController < UIViewController
  attr :container,
       :header_view,
       :footer_view,
       :top_layout_view,
       :bottom_layout_view,
       :center_view,
       :left_view,
       :top_right_view,
       :btm_right_view

  stylesheet :constraints

  layout :root do
    @container = subview(UIView, :container) do
      @header_view = subview(UIView, :header)
      @top_layout_view = subview(UIView, :top_layout)
      @footer_view = subview(UIView, :footer)
      @bottom_layout_view = subview(UIView, :bottom_layout)
      @center_view = subview(UIView, :center) do
        @left_view = subview(UIView, :left)
        @top_right_view = subview(UIView, :top_right)
        @btm_right_view = subview(UIView, :btm_right)
      end
    end
  end

  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAllButUpsideDown
  end

end


Teacup::Stylesheet.new :constraints do

  style :root,
    accessibilityLabel: 'root view'

  style :container,
    constraints: [:full],
    backgroundColor: UIColor.blackColor

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
      constrain(:height).equals(:header, :height),
    ]

  style :top_layout,
    backgroundColor: UIColor.orangeColor,
    constraints: [
      :full_width,
      constrain_below(:top_layout_guide)      
    ]

  style :bottom_layout,
    backgroundColor: UIColor.yellowColor,
    constraints: [
      :full_width,
      constrain_above(:bottom_layout_guide),
      constrain(:height).equals(10)
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
