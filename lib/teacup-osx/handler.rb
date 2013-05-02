module Teacup
  module_function

  def apply_method(target, assign, setter, value)
    if assign and target.respond_to?(assign)
      NSLog "Setting #{key} = #{value.inspect}" if target.respond_to? :debug and target.debug
      target.send(assign, value)
    elsif target.respondsToSelector(setter)
      NSLog "Calling target.#{setter}(#{value.inspect})" if target.respond_to? :debug and target.debug
      target.send(setter, value)
    else
      NSLog "TEACUP WARNING: Can't apply #{setter.inspect}#{assign and " or " + assign.inspect or ""} to #{target.inspect}"
    end
  end

end
