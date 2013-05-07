##|
##|  NSView.frame
##|
Teacup.handler NSView, :left, :x do |target, x|
  f = target.frame
  f.origin.x = Teacup::calculate(target, :width, x)
  target.frame = f
end

Teacup.handler NSView, :right do |target, r|
  f = target.frame
  f.origin.x = Teacup::calculate(target, :width, r) - f.size.width
  target.frame = f
end

Teacup.handler NSView, :center_x, :middle_x do |target, x|
  c = target.center
  c.x = Teacup::calculate(target, :width, x)
  target.center = c
end

Teacup.handler NSView, :top, :y do |target, y|
  f = target.frame
  f.origin.y = Teacup::calculate(target, :height, y)
  target.frame = f
end

Teacup.handler NSView, :bottom do |target, b|
  f = target.frame
  f.origin.y = Teacup::calculate(target, :height, b) - f.size.height
  target.frame = f
end

Teacup.handler NSView, :center_y, :middle_y do |target, y|
  c = target.center
  c.y = Teacup::calculate(target, :height, y)
  target.center = c
end

Teacup.handler NSView, :width do |target, w|
  f = target.frame
  f.size.width = Teacup::calculate(target, :width, w)
  target.frame = f
end

Teacup.handler NSView, :height do |target, h|
  f = target.frame
  f.size.height = Teacup::calculate(target, :height, h)
  target.frame = f
end

Teacup.handler NSView, :size do |target, size|
  f = target.frame
  size_x = Teacup::calculate(target, :width, size[0])
  size_y = Teacup::calculate(target, :height, size[1])
  f.size = [size_x, size_y]
  target.frame = f
end

Teacup.handler NSView, :origin do |target, origin|
  f = target.frame
  origin_x = Teacup::calculate(target, :width, origin[0])
  origin_y = Teacup::calculate(target, :height, origin[1])
  f.origin = [origin_x, origin_y]
  target.frame = f
end

Teacup.handler NSView, :center do |target, center|
  center_x = Teacup::calculate(target, :width, center[0])
  center_y = Teacup::calculate(target, :height, center[1])
  target.center = [center_x, center_y]
end

Teacup.handler NSView, :size do |target, size|
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

Teacup.handler NSView, :frame do |target, frame|
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
  elsif (Array === frame && frame.length == 2) || NSRect === frame
    frame = [
        [Teacup::calculate(target, :width, frame[0][0]), Teacup::calculate(target, :height, frame[0][1])],
        [Teacup::calculate(target, :width, frame[1][0]), Teacup::calculate(target, :height, frame[1][1])]
      ]
  end
  target.frame = frame
end

Teacup.handler NSView, :gradient do |target, gradient|
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
