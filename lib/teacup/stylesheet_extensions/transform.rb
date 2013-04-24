
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

  end

  class TransformLayer

    def identity
      [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]
    end

    # rotates the "up & down" direction.  The bottom of the view will rotate
    # towards the user as angle increases.
    def flip matrix, angle
      CATransform3DRotate(matrix, angle, 1, 0, 0)
    end

    # rotates the "left & right" direction.  The right side of the view will
    # rotate towards the user as angle increases.
    def twist matrix, angle
      CATransform3DRotate(matrix, angle, 0, 1, 0)
    end

    # spins, along the z axis.  This is probably the one you want, for
    # "spinning" a view like you might a drink coaster or paper napkin.
    def spin matrix, angle
      CATransform3DRotate(matrix, angle, 0, 0, 1)
    end

    # rotates the layer arbitrarily
    def rotate matrix, angle, x, y, z
      CATransform3DRotate(matrix, angle, x, y, z)
    end

  end

  class TransformView

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
      case point
      when CGPoint
        x = point.x
        y = point.y
      when Array
        x = point[0]
        y = point[1]
      else
        x = point
      end
      CGAffineTransformMakeTranslation(x, y)
    end

  end

end
