##|
##|  UIView.frame
##|
UIView.teacup_handler :left, :x { |view, x|
  f = view.frame
  f.origin.x = x
  view.frame = f
}

UIView.teacup_handler :right, :x { |view, r|
  f = view.frame
  f.origin.x = r - f.size.width
  view.frame = f
}

UIView.teacup_handler :top, :y { |view, y|
  f = view.frame
  f.origin.y = y
  view.frame = f
}

UIView.teacup_handler :bottom { |view, b|
  f = view.frame
  f.origin.y = b - f.size.height
  view.frame = f
}

UIView.teacup_handler :width { |view, w|
  f = view.frame
  f.size.width = w
  view.frame = f
}

UIView.teacup_handler :height { |view, h|
  f = view.frame
  f.size.height = h
  view.frame = f
}

UIView.teacup_handler :origin { |view, origin|
  f = view.frame
  f.origin = origin
  view.frame = f
}

UIView.teacup_handler :size { |view, size|
  f = view.frame
  f.size = size
  view.frame = f
}

##|
##|  UIButton
##|
UIButton.teacup_handler :title { |view, title|
  target.setTitle(title, forState: UIControlStateNormal)
}
