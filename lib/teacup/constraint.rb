module Teacup
  class Constraint
    attr_accessor :target
    attr_accessor :attribute
    attr_accessor :relationship
    attr_accessor :relative_to
    attr_accessor :attribute2
    attr_accessor :multiplier
    attr_accessor :constant
    attr_accessor :priority

    if defined? NSLayoutRelationEqual
      Priorities = {
        required: 1000,  # NSLayoutPriorityRequired
        high: 750,  # NSLayoutPriorityDefaultHigh
        medium: 500,
        low: 250,  # NSLayoutPriorityDefaultLow
      }
      Relationships = {
        equal: NSLayoutRelationEqual,
        lte: NSLayoutRelationLessThanOrEqual,
        gte: NSLayoutRelationGreaterThanOrEqual,
      }
      Attributes = {
        none: NSLayoutAttributeNotAnAttribute,
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
      when :center_x
        [
          Teacup::Constraint.new(:self, :center_x).equals(:superview, :center_x),
        ]
      when :center_y
        [
          Teacup::Constraint.new(:self, :center_y).equals(:superview, :center_y),
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
      when :top_left, :topleft
        [
          Teacup::Constraint.new(:self, :left).equals(relative_to, :left),
          Teacup::Constraint.new(:self, :top).equals(relative_to, :top),
        ]
      when :top_right, :topright
        [
          Teacup::Constraint.new(:self, :right).equals(relative_to, :right),
          Teacup::Constraint.new(:self, :top).equals(relative_to, :top),
        ]
      when :bottom_right, :bottomright
        [
          Teacup::Constraint.new(:self, :right).equals(relative_to, :right),
          Teacup::Constraint.new(:self, :bottom).equals(relative_to, :bottom),
        ]
      when :bottom_left, :bottomleft
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
      self.priority = :high
    end

    def equals(relative_to, attribute2=nil)
      self.set_relationship(NSLayoutRelationEqual, relative_to, attribute2)
    end

    def lte(relative_to, attribute2=nil)
      self.set_relationship(NSLayoutRelationLessThanOrEqual, relative_to, attribute2)
    end
    alias at_most lte
    alias is_at_most lte

    def gte(relative_to, attribute2=nil)
      self.set_relationship(NSLayoutRelationGreaterThanOrEqual, relative_to, attribute2)
    end
    alias at_least gte
    alias is_at_least gte

    def set_relationship(relation, relative_to, attribute2)
      if attribute2.nil?
        self.constant = relative_to
        self.relative_to = nil
        self.attribute2 = :none
      else
        self.relative_to = relative_to
        self.attribute2 = attribute2
      end
      self.relationship = relation

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

    def priority(priority=nil)
      return @priority if priority.nil?

      self.priority = priority
      self
    end

    def copy
      copy = Teacup::Constraint.new(self.target, self.attribute)
      copy.relationship = self.relationship
      copy.relative_to = self.relative_to
      copy.attribute2 = self.attribute2
      copy.multiplier = self.multiplier
      copy.constant = self.constant
      copy.priority = self.priority
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
                                           ) .tap do |nsconstraint|
        nsconstraint.priority = priority_lookup self.priority
      end
    end

private
    def attribute_lookup(attribute)
      return attribute if attribute.is_a? Fixnum
      raise "Unsupported attribute #{attribute.inspect}" unless Attributes.key? attribute
      Attributes[attribute]
    end

    def priority_lookup(priority)
      return priority if priority.is_a? Fixnum
      raise "Unsupported priority #{priority.inspect}" unless Priorities.key? priority
      Priorities[priority]
    end

    def relationship_lookup(relationship)
      return relationship if relationship.is_a? Fixnum
      raise "Unsupported relationship #{relationship.inspect}" unless Relationships.key? relationship
      Relationships[relationship]
    end

    def attribute_reverse(attribute)
      Attributes.key(attribute) || :none
    end

    def relationship_reverse(relationship)
      Relationships.key(relationship)
    end
  end
end
