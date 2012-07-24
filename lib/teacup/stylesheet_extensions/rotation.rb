
module Teacup

  class Stylesheet
    def identity
      [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]
    end

    def pi
      3.1415926
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

end
