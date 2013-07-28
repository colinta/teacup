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
          self.new(:self, :left).equals(relative_to, :left),
          self.new(:self, :top).equals(relative_to, :top),
          self.new(:self, :width).equals(relative_to, :width),
          self.new(:self, :height).equals(relative_to, :height),
        ]
      when :full_width
        [
          self.new(:self, :center_x).equals(relative_to, :center_x),
          self.new(:self, :width).equals(relative_to, :width),
        ]
      when :full_height
        [
          self.new(:self, :center_y).equals(relative_to, :center_y),
          self.new(:self, :height).equals(relative_to, :height),
        ]
      when :center_x
        [
          self.new(:self, :center_x).equals(:superview, :center_x),
        ]
      when :center_y
        [
          self.new(:self, :center_y).equals(:superview, :center_y),
        ]
      when :centered
        [
          self.new(:self, :center_x).equals(:superview, :center_x),
          self.new(:self, :center_y).equals(:superview, :center_y),
        ]
      when :top
        [
          self.new(:self, :top).equals(relative_to, :top),
        ]
      when :right
        [
          self.new(:self, :right).equals(relative_to, :right),
        ]
      when :bottom
        [
          self.new(:self, :bottom).equals(relative_to, :bottom),
        ]
      when :left
        [
          self.new(:self, :left).equals(relative_to, :left),
        ]
      when :top_left, :topleft
        [
          self.new(:self, :left).equals(relative_to, :left),
          self.new(:self, :top).equals(relative_to, :top),
        ]
      when :top_right, :topright
        [
          self.new(:self, :right).equals(relative_to, :right),
          self.new(:self, :top).equals(relative_to, :top),
        ]
      when :bottom_right, :bottomright
        [
          self.new(:self, :right).equals(relative_to, :right),
          self.new(:self, :bottom).equals(relative_to, :bottom),
        ]
      when :bottom_left, :bottomleft
        [
          self.new(:self, :left).equals(relative_to, :left),
          self.new(:self, :bottom).equals(relative_to, :bottom),
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
      self.priority = :high  # this is the xcode default
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
      if not self.relationship
        constant = -constant
      end
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
      copy = self.class.new(self.target, self.attribute)
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
      nsconstraint = NSLayoutConstraint.constraintWithItem( self.target,
                                  attribute: self.attribute,
                                  relatedBy: self.relationship,
                                     toItem: self.relative_to,
                                  attribute: self.attribute2,
                                 multiplier: self.multiplier,
                                   constant: self.constant
                                           )
      nsconstraint.priority = priority_lookup(self.priority)
      return nsconstraint
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
