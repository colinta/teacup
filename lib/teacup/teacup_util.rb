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

  # Returns all the subviews of `target` that have a stylename.  `target` is not
  # included in the list.  Used by the motion-layout integration in layout.rb.
  def get_styled_subviews(target)
    retval = target.subviews.select { |v| v.stylename }
    retval.concat(target.subviews.map do |subview|
      get_styled_subviews(subview)
    end)
    retval.flatten
  end

end