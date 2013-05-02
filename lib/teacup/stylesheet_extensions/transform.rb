
module Teacup
  class Stylesheet

    def pi
      Math::PI
    end

    def transform_view
      @@transform_layer ||= TransformView.new
    end

    def transform_layer
      @@transform_layer ||= TransformLayer.new
    end

    def identity
      NSLog("The Stylesheet method `identity` is deprecated, use `transform_layer.identity` instead")
      [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]
    end

  end

  class TransformLayer

    def identity
      [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]
    end

    # rotates the "up & down" direction.  The bottom of the view will rotate
    # towards the user as angle increases.
    def flip(angle)
      CATransform3DRotate(identity, angle, 1, 0, 0)
    end

    # rotates the "left & right" direction.  The right side of the view will
    # rotate towards the user as angle increases.
    def twist(angle)
      CATransform3DRotate(identity, angle, 0, 1, 0)
    end

    # spins, along the z axis.  This is probably the one you want, for
    # "spinning" a view like you might a drink coaster or paper napkin.
    def spin(angle)
      CATransform3DRotate(identity, angle, 0, 0, 1)
    end

    # rotates the layer arbitrarily
    def rotate(angle, x, y, z)
      CATransform3DRotate(identity, angle, x, y, z)
    end

  end

  class TransformView

    def identity
      [1, 0, 0, 1, 0, 0]
    end

    # Rotates the view counterclockwise
    def rotate angle
      CGAffineTransformMakeRotation(angle)
    end

    # Scales the view
    def scale scale_x, scale_y=nil
      scale_y ||= scale_x
      CGAffineTransformMakeScale(scale_x, scale_y)
    end

    # Translates the view
    def translate point, y=nil
      if point.respond_to?(:x) &&point.respond_to?(:y)
        x = point.x
        y = point.y
      elsif point.is_a? Array
        x = point[0]
        y = point[1]
      else
        x = point
      end
      CGAffineTransformMakeTranslation(x, y)
    end

  end

end
