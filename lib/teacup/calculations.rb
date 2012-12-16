module Teacup
  module_function
  def calculate(view, dimension, percent)
    if percent.is_a? Proc
      view.instance_exec(&percent)
    elsif percent.is_a? String and percent[-1] == '%'
      percent = percent[0...-1].to_f / 100.0

      case dimension
      when :width
        CGRectGetWidth(view.superview.bounds) * percent
      when :height
        CGRectGetHeight(view.superview.bounds) * percent
      end
    else
      percent
    end
  end
end
