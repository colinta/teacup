module Teacup
  # Stylesheets in Teacup act as a central configuration mechanism,
  # they have two aims:
  #
  # 1. Allow you to store "Details" away from the main body of your code.
  #    (controllers shouldn't have to be filled with style rules)
  # 2. Allow you to easily re-use configuration in many places.
  #
  # The API really provides only two methods, {Stylesheet#style} to store properties
  # on the Stylesheet; and {Stylesheet#query} to get them out again:
  #
  # @example
  #   stylesheet = Teacup::Stylesheet.new
  #   stylesheet.style :buttons, :corners => :rounded
  #   # => nil
  #   stylesheet.query :buttons
  #   # => {:corners => :rounded}
  #
  # In addition to this, two separate mechanisms are provided for sharing
  # configuration within stylesheets.
  #
  # Firstly, if you set the ':extends' property for a given stylename, then on lookup
  # the Stylesheet will merge the properties for the ':extends' stylename into the return
  # value. Conflicts are resolved so that properties with the original stylename
  # are resolved in its favour.
  #
  # @example
  #   Teacup::Stylesheet.new(:IPad) do
  #     style :button,
  #       background: UIColor.blackColor,
  #       top: 100
  #
  #     style :ok_button, extends: :button,
  #       title: "OK!",
  #       top: 200
  #
  #   end
  #   Teacup::Stylesheet::IPad.query(:ok_button)
  #   # => {background: UIColor.blackColor, top: 200, title: "OK!"}
  #
  # Secondly, you can import Stylesheets into each other, in exactly the same way as you
  # can include Modules into each other in Ruby. This allows you to share rules between
  # Stylesheets.
  #
  # As you'd expect, conflicts are resolve so that the Stylesheet on which you call query
  # has the highest precedence.
  #
  # @example
  #   Teacup::Stylesheet.new(:IPad) do
  #     style :ok_button,
  #       title: "OK!"
  #   end
  #
  #   Teacup::Stylesheet.new(:IPadVertical) do
  #     import :IPad
  #     style :ok_button,
  #       width: 80
  #   end
  #   Teacup::Stylesheet::IPadVertical.query(:ok_button)
  #   # => {title: "OK!", width: 80}
  #
  # The two merging mechanisms are considered independently, so you can override
  # a property both in a ':extends' rule, and also in an imported Stylesheet. In such a
  # a case the Stylesheet inclusion conflicts are resolved independently; and then in
  # a second phase, the ':extends' chain is flattened.
  #
  class Stylesheet
    attr_reader :name

    # Create a new Stylesheet.
    #
    # If a name is provided then a new constant will be created using that name.
    #
    # @param name, The (optional) name to give.
    # @param &block, The body of the Stylesheet instance_eval'd.
    #
    # @example
    #   Teacup::Stylesheet.new(:IPadVertical) do
    #     import :IPadBase
    #     style :continue_button,
    #        top: 50
    #   end
    #
    #   Teacup::Stylesheet::IPadVertical.query(:continue_button)
    #   # => {top: 50}
    #
    def initialize(name=nil, &block)
      if name
        @name = name.to_sym
        Teacup::Stylesheet.const_set(@name, self)
      end

      instance_eval &block
      self
    end

    # Include another Stylesheet into this one, the rules defined
    # within it will have lower precedence than those defined here
    # in the case that they share the same keys.
    #
    # @param Symbol|Teacup::Stylesheet  the name of the stylesheet,
    #                                   or the stylesheet to include.
    #
    # When defining a stylesheet declaratively, it is better to use the symbol
    # that represents a stylesheet, as the constant may not be defined yet:
    #
    # @example
    #   Teacup::Stylesheet.new(:IPadVertical) do
    #     import :IPadBase
    #     import :VerticalTweaks
    #   end
    #
    #
    # If you are using anonymous stylsheets however, then it will be necessary
    # to pass an actual stylesheet object.
    #
    # @example
    #   @stylesheet.import(base_stylesheet)
    #
    def import(name_or_stylesheet)
      imported << name_or_stylesheet
    end

    # Add a set of properties for a given stylename or set of stylenames.
    #
    # @param Symbol, *stylename
    # @param Hash[Symbol, Object], properties
    # @example
    #   Teacup::Stylesheet.new(:IPadBase) do
    #     style :pretty_button,
    #       backgroundColor: UIColor.blackColor
    #
    #     style :continue_button, extends: :pretty_button,
    #       title: "Continue!",
    #       top: 50
    #   end
    def style(*queries)
      properties = queries.pop
      queries.each do |stylename|
        styles[stylename].update(properties)
      end
    end

    # Get the properties defined for the given stylename, in this Stylesheet and all
    # those that have been imported.
    #
    # If the ':extends' property is set, we then repeat the process with the value
    # of that, and include them into the result with lower precedence.
    #
    # @param Symbol stylename, the stylename to look up.
    # @return Hash[Symbol, *] the resulting properties.
    # @example
    #   Teacup::Stylesheet::IPadBase.query(:continue_button)
    #   # => {backgroundColor: UIColor.blackColor, title: "Continue!", top: 50}
    def query(stylename)
      this_rule = properties_for(stylename)

      if also_include = this_rule.delete(:extends)
        query(also_include).merge(this_rule)
      else
        this_rule
      end
    end

    # A unique and hopefully meaningful description of this Object.
    #
    # @return String
    def inspect
      "Teacup::Stylesheet:#{name.inspect}"
    end

    protected

    # Get the properties for a given stylename, including any properties
    # defined on stylesheets that have been imported into this one, but not
    # resolving ':extends' inheritance.
    #
    # @param Symbol stylename, the stylename to search for.
    # @param Hash so_far, the properties already found in stylesheets with
    #                     lower precedence than this one.
    # @param Hash seen, the Stylesheets that we've already visited, this is
    #                   to avoid pathological cases where stylesheets
    #                   have been imported recursively.
    # @return Hash
    def properties_for(stylename, so_far={}, seen={})
      return so_far if seen[self]
      seen[self] = true

      imported_stylesheets.each do |stylesheet|
        stylesheet.properties_for(stylename, so_far, seen)
      end

      so_far.update(styles[stylename])
    end

    # The list of Stylesheets or names that have been imported into this one.
    #
    # @return Array[Symbol|Stylesheet]
    def imported
      @imported ||= []
    end

    # The array of Stylesheets that have been imported into this one.
    #
    # @return Array[Stylesheet]
    def imported_stylesheets
      imported.map do |name_or_stylesheet|
        if Teacup::Stylesheet === name_or_stylesheet
          name_or_stylesheet
        elsif Teacup::Stylesheet.const_defined?(name_or_stylesheet)
          Teacup::Stylesheet.const_get(name_or_stylesheet)
        else
          raise "Teacup tried to import Stylesheet:#{name_or_stylesheet.inspect} into Stylesheet:#{self.name}, but it didn't exist"
        end
      end
    end

    # The actual contents of this stylesheet as a Hash from stylename to properties.
    #
    # @return Hash[Symbol, Hash]
    def styles
      @styles ||= Hash.new{ |h, k| h[k] = {} }
    end
  end
end
