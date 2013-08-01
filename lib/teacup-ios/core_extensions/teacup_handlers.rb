##|
##|  Constraints
##|
Teacup.handler UIView, :constraints do |target, constraints|
  target.add_uniq_constraints(constraints)
end

##|
##|  UIView.frame
##|
Teacup.handler UIView, :left, :x do |target, x|
  f = target.frame
  f.origin.x = Teacup::calculate(target, :width, x)
  target.frame = f
end

Teacup.handler UIView, :right do |target, r|
  f = target.frame
  f.origin.x = Teacup::calculate(target, :width, r) - f.size.width
  target.frame = f
end

Teacup.handler UIView, :center_x, :middle_x do |target, x|
  c = target.center
  c.x = Teacup::calculate(target, :width, x)
  target.center = c
end

Teacup.handler UIView, :top, :y do |target, y|
  f = target.frame
  f.origin.y = Teacup::calculate(target, :height, y)
  target.frame = f
end

Teacup.handler UIView, :bottom do |target, b|
  f = target.frame
  f.origin.y = Teacup::calculate(target, :height, b) - f.size.height
  target.frame = f
end

Teacup.handler UIView, :center_y, :middle_y do |target, y|
  c = target.center
  c.y = Teacup::calculate(target, :height, y)
  target.center = c
end

Teacup.handler UIView, :width do |target, w|
  f = target.frame
  f.size.width = Teacup::calculate(target, :width, w)
  target.frame = f
end

Teacup.handler UIView, :height do |target, h|
  f = target.frame
  f.size.height = Teacup::calculate(target, :height, h)
  target.frame = f
end

Teacup.handler UIView, :size do |target, size|
  f = target.frame
  size_x = Teacup::calculate(target, :width, size[0])
  size_y = Teacup::calculate(target, :height, size[1])
  f.size = [size_x, size_y]
  target.frame = f
end

Teacup.handler UIView, :origin do |target, origin|
  f = target.frame
  origin_x = Teacup::calculate(target, :width, origin[0])
  origin_y = Teacup::calculate(target, :height, origin[1])
  f.origin = [origin_x, origin_y]
  target.frame = f
end

Teacup.handler UIView, :center do |target, center|
  center_x = Teacup::calculate(target, :width, center[0])
  center_y = Teacup::calculate(target, :height, center[1])
  target.center = [center_x, center_y]
end

Teacup.handler UIView, :size do |target, size|
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
end

Teacup.handler UIView, :frame do |target, frame|
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
end

Teacup.handler UIView, :gradient do |target, gradient|
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
end

##|
##|  UIButton
##|
Teacup.handler UIButton, :title do |target, title|
  if title.is_a?(NSAttributedString)
    target.setAttributedTitle(title, forState: UIControlStateNormal)
  else
    target.setTitle(title.to_s, forState: UIControlStateNormal)
  end
end


Teacup.handler UIButton, :image do |target, image|
  target.setImage(image, forState: UIControlStateNormal)
end


Teacup.handler UIButton, :backgroundImage do |target, background_image|
  target.setBackgroundImage(background_image, forState: UIControlStateNormal)
end


Teacup.handler UIButton, :titleColor do |target, color|
  target.setTitleColor(color, forState: UIControlStateNormal)
end


Teacup.handler UIButton, :titleFont, :font do |target, font|
  target.titleLabel.font = font
end


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

# this handler lyooks redundant, but without it Teacup would treat `attrs` as a
# stylable-property (the 'nested styling' feature)
Teacup.handler UINavigationBar, :titleTextAttributes do |view, attrs|
  view.titleTextAttributes = attrs
end
