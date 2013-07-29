module Teacup
  module_function

  def to_instance(class_or_instance)
    if class_or_instance.is_a? Class
      return class_or_instance.new
    else
      return class_or_instance
    end
  end

end
