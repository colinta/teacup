##|
##|  UIView.frame
##|
Teacup.handler UIView, :left, :x { |x|
  f = self.frame
  f.origin.x = Teacup::calculate(self, :width, x)
  self.frame = f
}

Teacup.handler UIView, :right { |r|
  f = self.frame
  f.origin.x = Teacup::calculate(self, :width, r) - f.size.width
  self.frame = f
}

Teacup.handler UIView, :center_x, :middle_x { |x|
  c = self.center
  c.x = Teacup::calculate(self, :width, x)
  self.center = c
}

Teacup.handler UIView, :top, :y { |y|
  f = self.frame
  f.origin.y = Teacup::calculate(self, :height, y)
  self.frame = f
}

Teacup.handler UIView, :bottom { |b|
  f = self.frame
  f.origin.y = Teacup::calculate(self, :height, b) - f.size.height
  self.frame = f
}

Teacup.handler UIView, :center_y, :middle_y { |y|
  c = self.center
  c.y = Teacup::calculate(self, :height, y)
  self.center = c
}

Teacup.handler UIView, :width { |w|
  f = self.frame
  f.size.width = Teacup::calculate(self, :width, w)
  self.frame = f
}

Teacup.handler UIView, :height { |h|
  f = self.frame
  f.size.height = Teacup::calculate(self, :height, h)
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
      size = self.superview.bounds.size
    else
      size = self.frame.size
    end
  elsif Array === size
    size = [Teacup::calculate(self, :width, size[0]), Teacup::calculate(self, :height, size[1])]
  end
  f = self.frame
  f.size = size
  self.frame = f
}

Teacup.handler UIView, :frame { |frame|
  # odd... if I changed these to .is_a?, weird errors happen.  Use ===
  if Symbol === frame && frame == :full
    if self.superview
      frame = self.superview.bounds
    else
      frame = self.frame
    end
  elsif Array === frame && frame.length == 4
    frame = [
        [Teacup::calculate(self, :width, frame[0]), Teacup::calculate(self, :height, frame[1])],
        [Teacup::calculate(self, :width, frame[2]), Teacup::calculate(self, :height, frame[3])]
      ]
  elsif Array === frame && frame.length == 2
    frame = [
        [Teacup::calculate(self, :width, frame[0][0]), Teacup::calculate(self, :height, frame[0][1])],
        [Teacup::calculate(self, :width, frame[1][0]), Teacup::calculate(self, :height, frame[1][1])]
      ]
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


Teacup.handler UIButton, :titleFont, :font { |font|
  font = font.uifont
  self.titleLabel.font = font
}
