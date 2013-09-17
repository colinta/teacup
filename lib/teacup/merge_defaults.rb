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
    constrained_attributes = left.map do |constraint|
      if constraint.respond_to? :attribute
        constraint.attribute
      else
        constraint
      end
    end
    additional_constraints = right.reject do |constraint|
      constraint.respond_to?(:attribute) && constrained_attributes.include?(constraint.attribute)
    end
    left + additional_constraints
  end

  # modifies left by passing it in as the `target`.
  def merge_defaults!(left, right)
    Teacup::merge_defaults(left, right, left)
  end
end
