module Teacup
  class Stylesheet

    def constrain(target, attribute=nil)
      if attribute.nil?
        attribute = target
        target = :self
      end
      Teacup::Constraint.new(target, attribute)
    end

    ##|
    def constrain_xy(x, y)
      [
        Teacup::Constraint.new(:self, :left).equals(:superview, :left).plus(x),
        Teacup::Constraint.new(:self, :top).equals(:superview, :top).plus(y),
      ]
    end

    def constrain_left(x)
      Teacup::Constraint.new(:self, :left).equals(:superview, :left).plus(x)
    end

    def constrain_right(x)
      Teacup::Constraint.new(:self, :right).equals(:superview, :right).plus(x)
    end

    def constrain_top(y)
      Teacup::Constraint.new(:self, :top).equals(:superview, :top).plus(y)
    end

    def constrain_bottom(y)
      Teacup::Constraint.new(:self, :bottom).equals(:superview, :bottom).plus(y)
    end

    def constrain_width(width)
      Teacup::Constraint.new(:self, :width).equals(width)
    end

    def constrain_height(height)
      Teacup::Constraint.new(:self, :height).equals(height)
    end

    def constrain_size(width, height)
      [
        Teacup::Constraint.new(:self, :right).equals(:self, :left).plus(width),
        Teacup::Constraint.new(:self, :bottom).equals(:self, :top).plus(height),
      ]
    end

    ##|
    def constrain_below(relative_to, margin=0)
      Teacup::Constraint.new(:self, :top).equals(relative_to, :bottom).plus(margin)
    end

    def constrain_above(relative_to, margin=0)
      Teacup::Constraint.new(:self, :bottom).equals(relative_to, :top).plus(margin)
    end

    def constrain_to_left(relative_to, margin=0)
      Teacup::Constraint.new(:self, :right).equals(relative_to, :left).plus(margin)
    end

    def constrain_to_right(relative_to, margin=0)
      Teacup::Constraint.new(:self, :left).equals(relative_to, :right).plus(margin)
    end

  end
end
