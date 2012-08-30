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
  #   Teacup::Stylesheet.new(:ipad) do
  #     style :button,
  #       backgroundImage: UIImage.imageNamed("big_red_shiny_button"),
  #       top: 100
  #
  #     style :ok_button, extends: :button,
  #       title: "OK!",
  #       top: 200
  #
  #   end
  #   Teacup::Stylesheet[:ipad].query(:ok_button)
  #   # => {backgroundImage: UIImage.imageNamed("big_red_shiny_button"), top: 200, title: "OK!"}
  #
  # Secondly, you can import Stylesheets into each other, in exactly the same way as you
  # can include Modules into each other in Ruby. This allows you to share rules between
  # Stylesheets.
  #
  # As you'd expect, conflicts are resolved so that the Stylesheet on which you
  # call query has the highest precedence.
  #
  # @example
  #   Teacup::Stylesheet.new(:ipad) do
  #     style :ok_button,
  #       title: "OK!"
  #   end
  #
  #   Teacup::Stylesheet.new(:ipadvertical) do
  #     import :ipad
  #     style :ok_button,
  #       width: 80
  #   end
  #   Teacup::Stylesheet[:ipadvertical].query(:ok_button)
  #   # => {title: "OK!", width: 80}
  #
  # The two merging mechanisms are considered independently, so you can override
  # a property both in a ':extends' rule, and also in an imported Stylesheet. In such a
  # a case the Stylesheet inclusion conflicts are resolved independently; and then in
  # a second phase, the ':extends' chain is flattened.
  #
  class Stylesheet
    attr_reader :name

    class << self
      def stylesheets
        @stylesheets ||= {}
      end

      def [] name
        stylesheets[name]
      end

      def []= name, stylesheet
        stylesheets[name] = stylesheet
      end
    end

    # Create a new Stylesheet.
    #
    # If a name is provided then a new constant will be created using that name.
    #
    # @param name, The (optional) name to give.
    # @param &block, The body of the Stylesheet instance_eval'd.
    #
    # @example
    #   Teacup::Stylesheet.new(:ipadvertical) do
    #     import :ipadbase
    #     style :continue_button,
    #        top: 50
    #   end
    #
    #   Teacup::Stylesheet[:ipadvertical].query(:continue_button)
    #   # => {top: 50}
    #
    def initialize(name=nil, &block)
      if name
        @name = name.to_sym
        if Teacup::Stylesheet[@name]
          NSLog("WARNING: A stylesheet with the name #{@name.inspect} has already been created.")
        end
        Teacup::Stylesheet[@name] = self
      end

      # we just store the block for now, because some classes are not "ready"
      # for instance, calling `UIFont.systemFontOfSize()` will cause the
      # application to crash.  We will lazily-load this block in `query`, and
      # then set it to nil.
      @block = block
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
    #   Teacup::Stylesheet.new(:ipadvertical) do
    #     import :ipadbase
    #     import :verticaltweaks
    #   end
    #
    #
    # If you are using anonymous stylesheets however, then it will be necessary
    # to pass an actual stylesheet object.
    #
    # @example
    #   @stylesheet.import(base_stylesheet)
    #
    def import(name_or_stylesheet)
      imported << name_or_stylesheet
    end

    # Get the properties defined for the given stylename, in this Stylesheet and
    # all those that have been imported.
    #
    # The Style class handles precedence rules, and extending via `:extends` and
    # `import`.  If needs the orientation in order to merge and remove the
    # appropriate orientation styles.
    #
    # @param Symbol stylename, the stylename to look up.
    # @return Hash[Symbol, *] the resulting properties.
    # @example
    #   Teacup::Stylesheet[:ipadbase].query(:continue_button)
    #   # => {backgroundImage: UIImage.imageNamed("big_red_shiny_button"), title: "Continue!", top: 50}
    def query(stylename, target=nil, orientation=nil, seen={})
      return {} if seen[self]

      # the block handed to Stylesheet#new is not run immediately - it is run
      # the first time the stylesheet is queried.  This fixes bugs related to
      # some resources (fonts) not available when the application is first
      # started.  The downside is that @instance variables and variables that
      # should be closed over are not.
      if @block
        instance_eval &@block
        @block = nil
      end
      seen[self] = true

      styles[stylename].build(target, orientation, seen)
    end

    # Add a set of properties for a given stylename or multiple stylenames.
    #
    # @param Symbol, *stylename
    # @param Hash[Symbol, Object], properties
    #
    # @example
    #   Teacup::Stylesheet.new(:ipadbase) do
    #     style :pretty_button,
    #       backgroundImage: UIImage.imageNamed("big_red_shiny_button")
    #
    #     style :continue_button, extends: :pretty_button,
    #       title: "Continue!",
    #       top: 50
    #   end
    def style(*queries)
      if queries[-1].is_a? Hash
        properties = queries.pop
      else
        # empty style declarations are allowed
        return
      end

      queries.each do |stylename|
        # merge into styles[stylename], new properties "win"
        Teacup::merge_defaults(properties, styles[stylename], styles[stylename])
      end
    end

    # A unique and hopefully meaningful description of this Object.
    #
    # @return String
    def inspect
      "Teacup::Stylesheet[#{name.inspect}] = #{styles.inspect}"
    end

    # The array of Stylesheets that have been imported into this one.
    #
    # @return Array[Stylesheet]
    def imported_stylesheets
      imported.map do |name_or_stylesheet|
        if name_or_stylesheet.is_a? Teacup::Stylesheet
          name_or_stylesheet
        elsif Teacup::Stylesheet.stylesheets.has_key? name_or_stylesheet
          Teacup::Stylesheet.stylesheets[name_or_stylesheet]
        else
          raise "Teacup tried to import Stylesheet #{name_or_stylesheet.inspect} into Stylesheet[#{self.name.inspect}], but it didn't exist"
        end
      end
    end

    protected

    # The list of Stylesheets or names that have been imported into this one.
    #
    # @return Array[Symbol|Stylesheet]
    def imported
      @imported ||= []
    end

    # The actual contents of this stylesheet as a Hash from stylename to properties.
    #
    # @return Hash[Symbol, Hash]
    def styles
      @styles ||= Hash.new{ |_styles, stylename|
        @styles[stylename] = Style.new
        @styles[stylename].stylename = stylename
        @styles[stylename].stylesheet = self
        @styles[stylename]
      }
    end

  end
end
