module Teacup
  class Stylesheet
    def constrain(target, attribute)
      Teacup::Constraint.new(target, attribute)
    end

    def constrain_left(x)
      Teacup::Constraint.new(target, :left).equals(:superview, :left).plus(x)
    end

    def constrain_top(y)
      Teacup::Constraint.new(target, :top).equals(:superview, :top).plus(y)
    end
  end
end
