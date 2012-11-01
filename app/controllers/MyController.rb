class MyController < UIViewController

  layout :root do
     subview(UIView, position: :relative, dimensions: [UIView::MAX_DIMENSION, 50], backgroundColor: UIColor.lightGrayColor) 
     subview(UIView, position: :relative, dimensions: [UIView::MAX_DIMENSION, 50], backgroundColor: UIColor.greenColor) 
  end
end
