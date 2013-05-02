module Teacup
  module_function

  def to_instance(class_or_instance)
    if class_or_instance.is_a? Class
      unless class_or_instance <= NSView
        raise "Expected subclass of NSView, got: #{class_or_instance.inspect}"
      end
      return class_or_instance.new
    elsif class_or_instance.is_a?(NSView)
      return class_or_instance
    else
      raise "Expected a NSView, got: #{class_or_instance.inspect}"
    end
  end

end
