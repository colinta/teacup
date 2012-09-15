##|
##|  UIView.frame
##|
Teacup.handler UIView, :left, :x { |x|
  f = self.frame
  f.origin.x = x
  self.frame = f
}

Teacup.handler UIView, :right { |r|
  f = self.frame
  f.origin.x = r - f.size.width
  self.frame = f
}

Teacup.handler UIView, :center_x, :middle_x { |x|
  c = self.center
  c.x = x
  self.center = c
}

Teacup.handler UIView, :top, :y { |y|
  f = self.frame
  f.origin.y = y
  self.frame = f
}

Teacup.handler UIView, :bottom { |b|
  f = self.frame
  f.origin.y = b - f.size.height
  self.frame = f
}

Teacup.handler UIView, :center_y, :middle_y { |y|
  c = self.center
  c.y = y
  self.center = c
}

Teacup.handler UIView, :width { |w|
  f = self.frame
  f.size.width = w
  self.frame = f
}

Teacup.handler UIView, :height { |h|
  f = self.frame
  f.size.height = h
  self.frame = f
}

Teacup.handler UIView, :origin { |origin|
  f = self.frame
  f.origin = origin
  self.frame = f
}

Teacup.handler UIView, :size { |size|
  # odd... if I changed these to .is_a?, weird errors happen.  Use ===
  if Symbol === size && size == :full
    if self.superview
      size = Size(self.superview.bounds.size)
    else
      size = self.frame.size
    end
  end
  f = self.frame
  f.size = size
  self.frame = f
}

Teacup.handler UIView, :frame { |frame|
  # odd... if I changed these to .is_a?, weird errors happen.  Use ===
  if Symbol === frame && frame == :full
    if self.superview
      frame = Rect(self.superview.bounds)
    else
      frame = self.frame
    end
  end
  self.frame = frame
}

##|
##|  UIButton
##|
Teacup.handler UIButton, :title { |title|
  self.setTitle(title, forState: UIControlStateNormal)
}


Teacup.handler UIButton, :titleColor { |color|
  self.setTitleColor(color.uicolor, forState: UIControlStateNormal)
}


Teacup.handler UIButton, :titleFont { |font|
  font = font.uifont
  self.titleLabel.font = font
}
