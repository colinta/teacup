##|
##|  UIView.frame
##|
Teacup.handler UIView, :left, :x { |view, x|
  f = view.frame
  f.origin.x = x
  view.frame = f
}

Teacup.handler UIView, :right { |view, r|
  f = view.frame
  f.origin.x = r - f.size.width
  view.frame = f
}

Teacup.handler UIView, :top, :y { |view, y|
  f = view.frame
  f.origin.y = y
  view.frame = f
}

Teacup.handler UIView, :bottom { |view, b|
  f = view.frame
  f.origin.y = b - f.size.height
  view.frame = f
}

Teacup.handler UIView, :width { |view, w|
  f = view.frame
  f.size.width = w
  view.frame = f
}

Teacup.handler UIView, :height { |view, h|
  f = view.frame
  f.size.height = h
  view.frame = f
}

Teacup.handler UIView, :origin { |view, origin|
  f = view.frame
  f.origin = origin
  view.frame = f
}

Teacup.handler UIView, :size { |view, size|
  f = view.frame
  f.size = size
  view.frame = f
}

##|
##|  UIButton
##|
Teacup.handler UIButton, :title { |view, title|
  view.setTitle(title, forState: UIControlStateNormal)
}
