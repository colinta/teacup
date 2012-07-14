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

    def teacup_assign keys*, &block
      if keys.length == 0
        raise TypeError.new "No style names assigned in Teacup::UIView##teacup_assign"
      elsif keys.length == 1 and Hash === keys[0]
        keys.each do |key, alias|
          teacup_handlers[alias] = proc { |view, value|
            teacup_apply view, key, value
          }
      else
        keys.each do |key|
          teacup_handlers[key] = block
        end
      end
      self
    end
  end

end
