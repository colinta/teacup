module Teacup
  class Constraint
    attr_accessor :target
    attr_accessor :attribute
    attr_accessor :relationship
    attr_accessor :relative_to
    attr_accessor :attribute2
    attr_accessor :multiplier
    attr_accessor :constant

    if defined? NSLayoutRelationEqual
      Relationships = {
        equal: NSLayoutRelationEqual,
        lte: NSLayoutRelationLessThanOrEqual,
        gte: NSLayoutRelationGreaterThanOrEqual,
      }
      Attributes = {
        left: NSLayoutAttributeLeft,
        right: NSLayoutAttributeRight,
        top: NSLayoutAttributeTop,
        bottom: NSLayoutAttributeBottom,
        leading: NSLayoutAttributeLeading,
        trailing: NSLayoutAttributeTrailing,
        width: NSLayoutAttributeWidth,
        height: NSLayoutAttributeHeight,
        center_x: NSLayoutAttributeCenterX,
        center_y: NSLayoutAttributeCenterY,
        baseline: NSLayoutAttributeBaseline,
      }
    else
      Relationships = {}
      Attributes = {}
    end

    def self.from_sym(sym, relative_to=:superview)
      case sym
      when :full
        [
          Teacup::Constraint.new(:self, :left).equals(relative_to, :left),
          Teacup::Constraint.new(:self, :top).equals(relative_to, :top),
          Teacup::Constraint.new(:self, :width).equals(relative_to, :width),
          Teacup::Constraint.new(:self, :height).equals(relative_to, :height),
        ]
      when :full_width
        [
          Teacup::Constraint.new(:self, :left).equals(relative_to, :left),
          Teacup::Constraint.new(:self, :width).equals(relative_to, :width),
        ]
      when :full_height
        [
          Teacup::Constraint.new(:self, :top).equals(relative_to, :top),
          Teacup::Constraint.new(:self, :height).equals(relative_to, :height),
        ]
      when :centered
        [
          Teacup::Constraint.new(:self, :center_x).equals(:superview, :center_x),
          Teacup::Constraint.new(:self, :center_y).equals(:superview, :center_y),
        ]
      when :top
        [
          Teacup::Constraint.new(:self, :top).equals(relative_to, :top),
        ]
      when :right
        [
          Teacup::Constraint.new(:self, :right).equals(relative_to, :right),
        ]
      when :bottom
        [
          Teacup::Constraint.new(:self, :bottom).equals(relative_to, :bottom),
        ]
      when :left
        [
          Teacup::Constraint.new(:self, :left).equals(relative_to, :left),
        ]
      when :top_left
        [
          Teacup::Constraint.new(:self, :left).equals(relative_to, :left),
          Teacup::Constraint.new(:self, :top).equals(relative_to, :top),
        ]
      when :top_right
        [
          Teacup::Constraint.new(:self, :right).equals(relative_to, :right),
          Teacup::Constraint.new(:self, :top).equals(relative_to, :top),
        ]
      when :bottom_right
        [
          Teacup::Constraint.new(:self, :right).equals(relative_to, :right),
          Teacup::Constraint.new(:self, :bottom).equals(relative_to, :bottom),
        ]
      when :bottom_left
        [
          Teacup::Constraint.new(:self, :left).equals(relative_to, :left),
          Teacup::Constraint.new(:self, :bottom).equals(relative_to, :bottom),
        ]
      else
        raise "Unknown symbol #{sym.inspect}"
      end
    end

    def initialize(target=nil, attribute=nil)
      self.target = target
      self.attribute = attribute
      self.constant = 0
      self.multiplier = 1
    end

    def equals(relative_to, attribute2)
      self.relative_to = relative_to
      self.attribute2 = attribute2
      self.relationship = NSLayoutRelationEqual

      self
    end

    def lte(relative_to, attribute2)
      self.relative_to = relative_to
      self.attribute2 = attribute2
      self.relationship = NSLayoutRelationLessThanOrEqual

      self
    end

    def gte(relative_to, attribute2)
      self.relative_to = relative_to
      self.attribute2 = attribute2
      self.relationship = NSLayoutRelationGreaterThanOrEqual

      self
    end

    def attribute=(attribute)
      @attribute = attribute_lookup attribute
    end

    def attribute2=(attribute)
      @attribute2 = attribute_lookup attribute
    end

    def times(multiplier)
      self.multiplier *= multiplier
      self
    end

    def divided_by(multiplier)
      times 1.0/multiplier
    end

    def plus(constant)
      self.constant += constant
      self
    end

    def minus(constant)
      plus -constant
    end

    def copy
      copy = Teacup::Constraint.new(self.target, self.attribute)
      copy.relationship = self.relationship
      copy.relative_to = self.relative_to
      copy.attribute2 = self.attribute2
      copy.multiplier = self.multiplier
      copy.constant = self.constant
      copy
    end

    def inspect
      "#<#{self.class.name} ##{object_id.to_s(16)}" +
      " target=#{target.inspect}" +
      " attribute=#{attribute_reverse(attribute).inspect}" +
      " relationship=#{relationship_reverse(relationship).inspect}" +
      " relative_to=#{relative_to.inspect}" +
      " attribute2=#{attribute_reverse(attribute2).inspect}" +
      " multiplier=#{multiplier.inspect}" +
      " constant=#{constant.inspect}" +
      ">"
    end

    def nslayoutconstraint
      NSLayoutConstraint.constraintWithItem( self.target,
                                  attribute: self.attribute,
                                  relatedBy: self.relationship,
                                     toItem: self.relative_to,
                                  attribute: self.attribute2,
                                 multiplier: self.multiplier,
                                   constant: self.constant
                                           )
    end

private
    def attribute_lookup(attribute)
      return attribute if attribute.is_a? Fixnum
      raise "Unsupported attribute #{attribute.nil}" unless Attributes.key? attribute
      Attributes[attribute]
    end

    def attribute_reverse(attribute)
      Attributes.key(attribute) || :none
    end

    def relationship_reverse(relationship)
      Relationships.key(relationship)
    end
  end
end

# constraintWithItem: target
#          attribute: attribute
#          relatedBy: relationship
#             toItem: relative_to
#          attribute: attribute2
#         multiplier: multiplier
#           constant: constant

