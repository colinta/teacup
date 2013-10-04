module Teacup
  module_function
  def calculate(view, dimension, amount)
    if amount.is_a? Proc
      view.instance_exec(&amount)
    elsif amount.is_a?(String) && amount.include?('%')
      location = amount.index '%'
      offset = amount.slice(location+1, amount.size).gsub(' ', '').to_f
      percent = amount.slice(0, location).to_f / 100.0

      case dimension
      when :width
        view.superview.bounds.size.width * percent + offset
      when :height
        view.superview.bounds.size.height * percent + offset
      else
        raise "Unknown dimension #{dimension}"
      end
    else
      amount
    end
  end
end
