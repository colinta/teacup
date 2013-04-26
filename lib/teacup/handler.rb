# Teacup handlers can modify (or alias) styling methods.  For instance, the
# UIButton class doesn't have a `title` attribute, but we all know that what we
# *mean* when we say `title: "button title"` is `setTitle("button title",
# forControlState:UIControlStateNormal)`. A UIButton handler accomplishes this
# translation.
#
# You can write your own handlers!
#
#     Teacup.handler UIButton, :title do |view, value|
#       view.setTitle(value, forControlState:UIControlStateNormal)
#     end
#
# You can declare multiple names in the Teacup.handler method to create aliases
# for your handler:
#
#    Teacup.handler UIButton, :returnKeyType, :returnkey { |view, keytype|
#      view.setReturnKeyType(keytype)
#    }
#
# Since teacup already supports translating a property like `returnKeyType` into
# the setter `setReturnKeyType`, you could just use an alias here instead.
# Assign a hash to `Teacup.alias`:
#
#     Teacup.alias UIButton, :returnkey => :returnKeyType
module Teacup
  module_function

  # applies a Hash of styles, and converts the frame styles (origin, size, top,
  # left, width, height) into one frame property.
  #
  # For UIAppearance support, the class of the UIView class that is being
  # modified can be passed in
  def apply_hash(target, properties, klass=nil)
    properties.each do |key, value|
      Teacup.apply target, key, value, klass
    end
  end

  # Applies a single style to a target.  Delegates to a teacup handler if one is
  # found.
  def apply(target, key, value, klass=nil)
    # note about `debug`: not all objects in this method are a UIView instance,
    # so don't assume that the object *has* a debug method.
    if value.is_a? Proc
      if value.arity == 1
        value = value.call(target)
      else
        value = target.instance_exec(&value)
      end
    end

    klass ||= target.class
    handled = false
    klass.ancestors.each do |ancestor|
      if Teacup.handlers[ancestor].has_key? key
        NSLog "#{ancestor.name} is handling #{key} = #{value.inspect}"  if target.respond_to? :debug and target.debug
        if Teacup.handlers[ancestor][key].arity == 1
          target.instance_exec(value, &Teacup.handlers[ancestor][key])
        else
          Teacup.handlers[ancestor][key].call(target, value)
        end
        handled = true
        break
      end
    end
    return if handled

    # you can send methods to subviews (e.g. UIButton#titleLabel) and CALayers
    # (e.g. UIView#layer) by assigning a hash to a style name.
    if value.is_a? Hash
      return Teacup.apply_hash target.send(key), value
    end

    if key =~ /^set[A-Z]/
      assign = nil
      setter = key.to_s + ':'
    else
      assign = key.to_s + '='
      setter = 'set' + key.to_s.sub(/^./) {|c| c.capitalize} + ':'
    end

    if assign and target.respond_to?(assign)
      NSLog "Setting #{key} = #{value.inspect}" if target.respond_to? :debug and target.debug
      target.send(assign, value)
    elsif target.respondsToSelector(setter)
      NSLog "Calling target.#{setter}(#{value.inspect})" if target.respond_to? :debug and target.debug
      target.send(setter, value)
    elsif target.is_a?(self.AppearanceClass)
      NSLog "Calling target.#{setter}(#{value.inspect})" if target.respond_to? :debug and target.debug
      target.send(setter, value)
    else
      NSLog "TEACUP WARNING: Can't apply #{setter.inspect}#{assign and " or " + assign.inspect or ""} to #{target.inspect}"
    end
  end

  def AppearanceClass
    @appearance_klass ||= UIView.appearance.class
  end

  def handlers
    @teacup_handlers ||= Hash.new{ |hash,klass| hash[klass] = {} }
  end

  def handler klass, *stylenames, &block
    if stylenames.length == 0
      raise TypeError.new "No style names assigned in Teacup[#{klass.inspect}]##handler"
    else
      stylenames.each do |stylename|
        Teacup.handlers[klass][stylename] = block
      end
    end
    self
  end

  def alias klass, aliases
    aliases.each do |style_alias, style_name|
      Teacup.handlers[klass][style_alias] = proc { |view, value|
        Teacup.apply view, style_name, value
      }
    end
    self
  end

end