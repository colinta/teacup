class ConstraintsController < UIViewController
  attr :header_view,
       :footer_view,
       :center_view,
       :left_view,
       :top_right_view,
       :btm_right_view

  stylesheet :constraints

  layout :root do
    @header_view = subview(UIView, :header)
    @footer_view = subview(UIView, :footer)
    @center_view = subview(UIView, :center) do
      @left_view = subview(UIView, :left)
      @top_right_view = subview(UIView, :top_right)
      @btm_right_view = subview(UIView, :btm_right)
    end
  end

end


Teacup::Stylesheet.new :constraints do

  style :root,
    autoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight,
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
