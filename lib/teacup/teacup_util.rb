module Teacup
  module_function

  def to_instance(class_or_instance)
    if class_or_instance.is_a? Class
      unless class_or_instance <= UIView
        raise "Expected subclass of UIView, got: #{class_or_instance.inspect}"
      end
      return class_or_instance.new
    elsif class_or_instance.is_a?(UIView)
      return class_or_instance
    else
      raise "Expected a UIView, got: #{class_or_instance.inspect}"
    end
  end

  def get_subviews(target)
    [target] + target.subviews.map do |subview|
      get_subviews(subview).select { |v| v.stylename }
    end.flatten
  end

end