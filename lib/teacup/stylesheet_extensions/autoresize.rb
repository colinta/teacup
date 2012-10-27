# Example:
#     Teacup::Stylesheet.new :main do
#       style :root,
#         # stays centered and grows in height
#         autoresizingMask: left|right|height
#     end
module Teacup
  class Stylesheet

    def none
      UIViewAutoresizingNone
    end

    def flexible_left
      UIViewAutoresizingFlexibleLeftMargin
    end

    def flexible_width
      UIViewAutoresizingFlexibleWidth
    end

    def flexible_right
      UIViewAutoresizingFlexibleRightMargin
    end

    def flexible_top
      UIViewAutoresizingFlexibleTopMargin
    end

    def flexible_height
      UIViewAutoresizingFlexibleHeight
    end

    def flexible_bottom
      UIViewAutoresizingFlexibleBottomMargin
    end

  end
end
