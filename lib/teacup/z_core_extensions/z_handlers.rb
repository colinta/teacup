##|
##|  UIView.frame
##|
Teacup.handler UIView, :left, :x { |target, x|
  f = target.frame
  f.origin.x = Teacup::calculate(target, :width, x)
  target.frame = f
}

Teacup.handler UIView, :right { |target, r|
  f = target.frame
  f.origin.x = Teacup::calculate(target, :width, r) - f.size.width
  target.frame = f
}

Teacup.handler UIView, :center_x, :middle_x { |target, x|
  c = target.center
  c.x = Teacup::calculate(target, :width, x)
  target.center = c
}

Teacup.handler UIView, :top, :y { |target, y|
  f = target.frame
  f.origin.y = Teacup::calculate(target, :height, y)
  target.frame = f
}

Teacup.handler UIView, :bottom { |target, b|
  f = target.frame
  f.origin.y = Teacup::calculate(target, :height, b) - f.size.height
  target.frame = f
}

Teacup.handler UIView, :center_y, :middle_y { |target, y|
  c = target.center
  c.y = Teacup::calculate(target, :height, y)
  target.center = c
}

Teacup.handler UIView, :width { |target, w|
  f = target.frame
  f.size.width = Teacup::calculate(target, :width, w)
  target.frame = f
}

Teacup.handler UIView, :height { |target, h|
  f = target.frame
  f.size.height = Teacup::calculate(target, :height, h)
  target.frame = f
}

Teacup.handler UIView, :size { |target, size|
  f = target.frame
  size_x = Teacup::calculate(target, :width, size[0])
  size_y = Teacup::calculate(target, :height, size[1])
  f.size = [size_x, size_y]
  target.frame = f
}

Teacup.handler UIView, :origin { |target, origin|
  f = target.frame
  origin_x = Teacup::calculate(target, :width, origin[0])
  origin_y = Teacup::calculate(target, :height, origin[1])
  f.origin = [origin_x, origin_y]
  target.frame = f
}

Teacup.handler UIView, :center { |target, center|
  center_x = Teacup::calculate(target, :width, center[0])
  center_y = Teacup::calculate(target, :height, center[1])
  target.center = [center_x, center_y]
}

Teacup.handler UIView, :size { |target, size|
  # odd... if I changed these to .is_a?, weird errors happen.  Use ===
  if Symbol === size && size == :full
    if target.superview
      size = target.superview.bounds.size
    else
      size = target.frame.size
    end
  elsif Array === size
    size = [Teacup::calculate(target, :width, size[0]), Teacup::calculate(target, :height, size[1])]
  end
  f = target.frame
  f.size = size
  target.frame = f
}

Teacup.handler UIView, :frame { |target, frame|
  # odd... if I changed these to .is_a?, weird errors happen.  Use ===
  if Symbol === frame && frame == :full
    if target.superview
      frame = target.superview.bounds
    else
      frame = target.frame
    end
  elsif Array === frame && frame.length == 4
    frame = [
        [Teacup::calculate(target, :width, frame[0]), Teacup::calculate(target, :height, frame[1])],
        [Teacup::calculate(target, :width, frame[2]), Teacup::calculate(target, :height, frame[3])]
      ]
  elsif (Array === frame && frame.length == 2) || CGRect === frame
    frame = [
        [Teacup::calculate(target, :width, frame[0][0]), Teacup::calculate(target, :height, frame[0][1])],
        [Teacup::calculate(target, :width, frame[1][0]), Teacup::calculate(target, :height, frame[1][1])]
      ]
  end
  target.frame = frame
}

Teacup.handler UIView, :gradient { |target, gradient|
  gradient_layer = target.instance_variable_get(:@teacup_gradient_layer) || begin
    gradient_layer = CAGradientLayer.layer
    gradient_layer.frame = target.bounds
    target.layer.insertSublayer(gradient_layer, atIndex:0)
    gradient_layer
  end

  gradient.each do |key, value|
    case key.to_s
    when 'colors'
      colors = [value].flatten.collect { |color| color.is_a?(UIColor) ? color.CGColor : color }
      gradient_layer.colors = colors
    else
      gradient_layer.send("#{key}=", value)
    end
  end

  target.instance_variable_set(:@teacup_gradient_layer, gradient_layer)
}

##|
##|  UIButton
##|
Teacup.handler UIButton, :title { |target, title|
  target.setTitle(title, forState: UIControlStateNormal)
}


Teacup.handler UIButton, :image { |target, image|
  target.setImage(image, forState: UIControlStateNormal)
}


Teacup.handler UIButton, :backgroundImage { |target, background_image|
  target.setBackgroundImage(background_image, forState: UIControlStateNormal)
}


Teacup.handler UIButton, :titleColor { |target, color|
  target.setTitleColor(color, forState: UIControlStateNormal)
}


Teacup.handler UIButton, :titleFont, :font { |target, font|
  font = font.uifont
  target.titleLabel.font = font
}


##|
##|  UINavigationBar
##|
Teacup.handler UINavigationBar, :backgroundImage do |styles|
  if styles.is_a?(UIImage)
    styles = { portrait: styles }
  end

  styles.each do |metric, image|
    case metric
    when UIBarMetricsDefault, :portrait
      self.setBackgroundImage(image && image.uiimage, forBarMetrics:UIBarMetricsDefault)
    when UIBarMetricsLandscapePhone, :landscape
      self.setBackgroundImage(image && image.uiimage, forBarMetrics:UIBarMetricsLandscapePhone)
    end
  end
end
