# teacup_handlers can modify (or alias) styling methods.  For instance, the
# UIButton class doesn't have a `title` attribute, but we all know that what we
# *mean* when we say `title: "button title"` is `setTitle("button title",
# forControlState:UIControlStateNormal)`. A UIButton handler accomplishes this
# translation.
#
# You can write your own handlers!
#
#     UIButton.teacup_handler :title do |view, value|
#       view.setTitle(value, forControlState:UIControlStateNormal)
#     end
#
# You can declare multiple names in the teacup_handler method to create aliases
# for your handler:
#
#    UIButton.teacup_assign :returnKeyType, :returnkey { |view, keytype|
#      view.setReturnKeyType(keytype)
#    }
#
# Since teacup already supports translating a property like `returnKeyType` into
# the setter `setReturnKeyType`, you could just alias.  Assign a hash to
# `teacup_assign`:
#
#     UIButton.teacup_assign returnKeyType: :returnkey
class UIView

  class << self
    def teacup_handlers
      @teacup_handlers ||= {}
    end

    def teacup_assign *stylenames, &block
      if stylenames.length == 0
        raise TypeError.new "No style names assigned in Teacup::UIView##teacup_assign"
      elsif stylenames.length == 1 and Hash === stylenames[0]
        stylenames.each do |stylename, style_alias|
          teacup_handlers[style_alias] = proc { |view, value|
            teacup_apply view, style_name, value
          }
        end
      else
        stylenames.each do |stylename|
          teacup_handlers[stylename] = block
        end
      end
      self
    end
  end

end
