module Teacup
  # Sheets in Teacup act as a central configuration mechanism,
  # they have two aims:
  #
  # 1. Allow you to store "Details" away from the main body of your code.
  #    (controllers shouldn't have to be filled with style rules)
  # 2. Allow you to easily re-use configuration in many places.
  #
  # The API really provides only two methods, {Sheet#style} to store properties
  # on the Sheet; and {Sheet#query} to get them out again:
  #
  # @example
  #   sheet = Teacup::Sheet.new
  #   sheet.style :buttons, :corners => :rounded
  #   # => nil
  #   sheet.query :buttons
  #   # => {:corners => :rounded}
  #
  # In addition to this, two separate mechanisms are provided for sharing
  # configuration within sheets.
  #
  # Firstly, if you set the ':like' property for a given query, then on lookup
  # the Sheet will merge the properties for the ':like' query into the return
  # value. Conflicts are resolved so that properties with the original query
  # are resolved in its favour.
  #
  # @example
  #   Teacup::Sheet.new(:IPad) do
  #     style :button,
  #       background: UIColor.blackColor,
  #       top: 100
  #
  #     style :ok_button, like: :button,
  #       title: "OK!",
  #       top: 200
  #
  #   end
  #   Teacup::Sheet::IPad.query(:ok_button)
  #   # => {background: UIColor.blackColor, top: 200, title: "OK!"}
  #
  # Secondly, you can include Sheets into each other, in exactly the same way as you
  # can include Modules into each other in Ruby. This allows you to share rules between
  # Sheets.
  #
  # As you'd expect, conflicts are resolve so that the Sheet on which you call query
  # has the highest precedence.
  #
  # @example
  #   Teacup::Sheet.new(:IPad) do
  #     style :ok_button,
  #       title: "OK!"
  #   end
  #
  #   Teacup::Sheet.new(:IPadVertical) do
  #     include :IPad
  #     style :ok_button,
  #       width: 80
  #   end
  #   Teacup::Sheet::IPadVertical.query(:ok_button)
  #   # => {title: "OK!", width: 80}
  #
  # The two merging mechanisms are considered independently, so you can override
  # a property both in a ':like' rule, and also in an included Sheet. In such a
  # a case the Sheet inclusion conflicts are resolved independently; and then in
  # a second phase, the ':like' chain is flattened.
  #
  class StyleSheet
    attr_reader :name

    # Create a new Sheet with the given name.
    #
    # @param name, The name to give.
    # @param &block, The body of the Sheet instance_eval'd.
    # @example
    #   Teacup::Sheet.new(:IPadVertical) do
    #     include :IPadBase
    #     style :continue_button,
    #        top: 50
    #   end
    #
    def initialize(name, &block)
      @name = name.to_sym
      Teacup::StyleSheet.const_set(@name, self)
      instance_eval &block
      self
    end

    # Include another Sheet into this one, the rules defined
    # within it will have lower precedence than those defined here
    # in the case that they share the same keys.
    #
    # @param Symbol the name of the sheet.
    # @example
    #   Teacup::Sheet.new(:IPadVertical) do
    #     include :IPadBase
    #     include :VerticalTweaks
    #   end
    def include(name_or_sheet)
      if StyleSheet === name_or_sheet
        included << name_or_sheet.name
      else
        included << name_or_sheet.to_sym
      end
    end

    # Add a set of properties for a given query or queries.
    #
    # @param Symbol, *query
    # @param Hash[Symbol, Object], properties
    # @example
    #   Teacup::Sheet.new(:IPadBase) do
    #     style :pretty_button,
    #       backgroundColor: UIColor.blackColor
    #
    #     style :continue_button, like: :pretty_button,
    #       title: "Continue!",
    #       top: 50
    #   end
    def style(*queries)
      properties = queries.pop
      queries.each do |query|
        styles[query].update(properties)
      end
    end

    # Get the properties defined for the given query, in this Sheet and all
    # those that are included.
    #
    # If the ':like' property is set, we then repeat the process with the value
    # of that, and include them into the result with lower precedence.
    #
    # @param Symbol query, the query to look up.
    # @return Hash[Symbol, *] the resulting properties.
    # @example
    #   Teacup::Sheet::IPadBase.query(:continue_button)
    #   # => {backgroundColor: UIColor.blackColor, title: "Continue!", top: 50}
    def query(query)
      this_rule = properties_for(query)

      if also_include = this_rule.delete(:like)
        query(also_include).merge(this_rule)
      else
        this_rule
      end
    end

    # A unique and hopefully meaningful description of this Object.
    #
    # @return String
    def inspect
      "Teacup::StyleSheet:#{name.inspect}"
    end

    protected

    # Get the properties for a given query, including any properties
    # defined on sheets that have been included into this one, but not
    # resolving ':like' inheritance.
    #
    # @param Symbol query, the query to search for.
    # @param Hash so_far, the properties already found in sheets with
    #                     lower precedence than this one.
    # @param Hash seen, the Sheets that we've already visited, this is
    #                   to avoid pathological cases where stylesheets
    #                   have been included recursively.
    # @return Hash
    def properties_for(query, so_far={}, seen={})
      return so_far if seen[self]
      seen[self] = true

      included.each do |name|
        unless Teacup::StyleSheet.const_defined?(name)
          raise "Teacup tried to include Sheet:#{name} into Sheet:#{self.name}, but it didn't exist"
        end
        Teacup::StyleSheet.const_get(name).properties_for(query, so_far, seen)
      end

      so_far.update(styles[query])
    end

    # The list of Sheet names that have been included in this one.
    #
    # @return Array[Symbol]
    def included
      @included ||= []
    end

    # The actual contents of this sheet as a Hash from query to properties.
    #
    # @return Hash[Symbol, Hash]
    def styles
      @styles ||= Hash.new{ |h, k| h[k] = {} }
    end
  end
end
