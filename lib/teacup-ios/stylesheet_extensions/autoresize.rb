# Example:
#     Teacup::Stylesheet.new :main do
#       style :root,
#         # stays centered and grows in height
#         autoresizingMask: autoresize.flexible_left | autoresize.flexible_right | autoresize.flexible_height
#         # same, in block form
#         autoresizingMask: autoresize { flexible_left | flexible_right | flexible_height }
#     end
module Teacup
  module StylesheetExtension

    def autoresize &block
      @@autoresize ||= Autoresize.new
      if block
        return @@autoresize.instance_exec &block
      else
        return @@autoresize
      end
    end

    ##|
    ##|  DEPRECATED
    ##|

    def flexible_left
      NSLog("The Stylesheet method `flexible_left` is deprecated, use `autoresize.flexible_left` instead")
      UIViewAutoresizingFlexibleLeftMargin
    end

    def flexible_width
      NSLog("The Stylesheet method `flexible_width` is deprecated, use `autoresize.flexible_width` instead")
      UIViewAutoresizingFlexibleWidth
    end

    def flexible_right
      NSLog("The Stylesheet method `flexible_right` is deprecated, use `autoresize.flexible_right` instead")
      UIViewAutoresizingFlexibleRightMargin
    end

    def flexible_top
      NSLog("The Stylesheet method `flexible_top` is deprecated, use `autoresize.flexible_top` instead")
      UIViewAutoresizingFlexibleTopMargin
    end

    def flexible_height
      NSLog("The Stylesheet method `flexible_height` is deprecated, use `autoresize.flexible_height` instead")
      UIViewAutoresizingFlexibleHeight
    end

    def flexible_bottom
      NSLog("The Stylesheet method `flexible_bottom` is deprecated, use `autoresize.flexible_bottom` instead")
      UIViewAutoresizingFlexibleBottomMargin
    end

  end

  class Autoresize

    def none
      UIViewAutoresizingNone
    end

    ##|
    ##|  FLEXIBLE
    ##|

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

    ##|
    ##|  FILL
    ##|

    def fill
      flexible_width | flexible_height
    end

    def fill_top
      flexible_width | flexible_bottom
    end

    def fill_bottom
      flexible_width | flexible_top
    end

    def fill_left
      flexible_height | flexible_right
    end

    def fill_right
      flexible_height | flexible_left
    end

    ##|
    ##|  FIXED
    ##|

    def fixed_top_left
      flexible_right | flexible_bottom
    end

    def fixed_top_middle
      flexible_left | flexible_right | flexible_bottom
    end

    def fixed_top_right
      flexible_left | flexible_bottom
    end

    def fixed_middle_left
      flexible_top | flexible_bottom | flexible_right
    end

    def fixed_middle
      flexible_top | flexible_bottom | flexible_left | flexible_right
    end

    def fixed_middle_right
      flexible_top | flexible_bottom | flexible_left
    end

    def fixed_bottom_left
      flexible_right | flexible_top
    end

    def fixed_bottom_middle
      flexible_left | flexible_right | flexible_top
    end

    def fixed_bottom_right
      flexible_left | flexible_top
    end

    ##|
    ##|  FLOAT
    ##|

    def float_horizontal
      flexible_left | flexible_right
    end

    def float_vertical
      flexible_top | flexible_bottom
    end

  end

end
