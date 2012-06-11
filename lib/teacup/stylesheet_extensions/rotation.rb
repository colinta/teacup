
module Teacup

  class Stylesheet
    def identity
      [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]
    end

    def pi
      3.1415926
    end

    # rotates the "up & down" direction
    def flip matrix, angle
      CATransform3DRotate(matrix, angle, 1, 0, 0)
    end

    # rotates the "left & right" direction
    def twist matrix, angle
      CATransform3DRotate(matrix, angle, 0, 1, 0)
    end

    # spins, along the z axis
    def spin matrix, angle
      CATransform3DRotate(matrix, angle, 0, 0, 1)
    end

    # rotates the layer arbitrarily
    def rotate matrix, angle, x, y, z
      CATransform3DRotate(matrix, angle, x, y, z)
    end

  end

end
