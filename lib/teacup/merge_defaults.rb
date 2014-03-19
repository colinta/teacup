module Teacup
  module_function

  # Merges two Hashes.  This is similar to `Hash#merge`, except the values will
  # be merged recursively (aka deep merge) when both values for a key are
  # Hashes, and values for the *left* argument are preferred over values on the
  # right.
  #
  # If you pass in a third argument, it will be acted upon directly instead of
  # creating a new Hash.  Usually used with `merge_defaults!`, which merges values
  # from `right` into `left`.
  def merge_defaults(left, right, target={})
    if target != left
      left.each do |key, value|
        if target.has_key? key and value.is_a?(Hash) and target[key].is_a?(Hash)
          target[key] = Teacup::merge_defaults(target[key], value)
        else
          if value.is_a?(Hash)
            # make a copy of the Hash
            value = Teacup::merge_defaults!({}, value)
          end
          target[key] = value
        end
      end
    end

    right.each do |key, value|
      if not target.has_key? key
        target[key] = value
      elsif value.is_a?(Hash) and left[key].is_a?(Hash)
        target[key] = Teacup::merge_defaults(left[key], value, (left==target ? left[key] : {}))
      elsif key == :constraints
        left[key] = merge_constraints(left[key], value)
      end
    end
    target
  end

  # constraints are a special case because when we merge an array of constraints
  # we need to make sure not to add more than one constraint for a given attribute
  def merge_constraints(left, right)
    left = left.map do |constraint|
      convert_constraints(constraint)
    end.flatten
    right = right.map do |constraint|
      convert_constraints(constraint)
    end.flatten

    constrained_attributes = left.map do |constraint|
      constraint.attribute
    end
    additional_constraints = right.reject do |constraint|
      constrained_attributes.include?(constraint.attribute)
    end
    left + additional_constraints
  end

  def convert_constraints(constraints)
    if constraints.is_a? Array
      constraints.map do |constraint|
        convert_constraints(constraint)
      end
    elsif constraints.is_a? Hash
      constraints.map do |sym, relative_to|
        convert_constraints(Teacup::Constraint.from_sym(sym, relative_to))
      end
    elsif constraints.is_a?(Symbol)
      Teacup::Constraint.from_sym(constraints)
    elsif constraints.is_a?(Teacup::Constraint)
      constraints
    else
      raise "Unsupported constraint: #{constraints.inspect}"
    end
  end

  # modifies left by passing it in as the `target`.
  def merge_defaults!(left, right)
    Teacup::merge_defaults(left, right, left)
  end
end
