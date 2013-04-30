module Teacup
  # An interface to style views using the UIAppearance protocol.
  #
  # Work similarly as the Stylesheet class.
  #
  # @example
  #
  # Teacup::Appearance.new do
  #
  #   style UINavigationBar,
  #     tintColor: UIColor.colorWithRed(0.886, green:0.635, blue:0, alpha: 1)
  #
  # end
  class Appearance < Stylesheet
    TeacupAppearanceApplyNotification = 'TeacupAppearanceApplyNotification'

    def self.apply
      NSNotificationCenter.defaultCenter.postNotificationName(TeacupAppearanceApplyNotification, object:nil)
    end

    # Contains a list of styles associated with "containers".  These do not get
    # merged like the usual `style` declarations.
    def when_contained_in
      @when_contained_in ||= []
    end

    # disable the stylesheet 'name' parameter, and assign the "super secret"
    # stylesheet name
    def initialize(&block)
      NSNotificationCenter.defaultCenter.addObserver(self,
              selector: :'apply_appearance:',
              name: UIApplicationDidFinishLaunchingNotification,
              object: nil)
      NSNotificationCenter.defaultCenter.addObserver(self,
              selector: :'apply_appearance:',
              name: TeacupAppearanceApplyNotification,
              object: nil)

      super(&block)
    end

    def exclude_instance_vars
      @exclude_instance_vars ||= super + [:@when_contained_in]
    end

    # Styles that have the `when_contained_in` setting need to be kept separate
    def style(*queries)
      # do not modify queries, it gets passed to `super`
      if queries[-1].is_a? Hash
        properties = queries[-1]
      else
        # empty style declarations are allowed, but accomplish nothing.
        return
      end

      if properties.include?(:when_contained_in)
        # okay NOW modify queries
        queries.pop
        queries.each do |stylename|
          style = Style.new
          style.stylename = stylename
          style.stylesheet = self
          style.merge!(properties)

          when_contained_in << [stylename, style]
        end
      else
        super
      end
    end

    # This block is only run once, and the properties object from
    # when_contained_in is a copy (via Teacup::Style.new), so we remove the
    # when_contained_in property using `delete`
    def apply_appearance(notification=nil)
      return unless run_block
      NSNotificationCenter.defaultCenter.removeObserver(self, name:UIApplicationDidFinishLaunchingNotification, object:nil)
      NSNotificationCenter.defaultCenter.removeObserver(self, name:TeacupAppearanceApplyNotification, object:nil)

      when_contained_in.each do |klass, properties|
        contained_in = properties.delete(:when_contained_in)
        contained_in = [contained_in] unless contained_in.is_a?(NSArray)
        # make a copy and add nil to the end
        contained_in += [nil]
        appearance = klass.send(:'appearanceWhenContainedIn:', *contained_in)
        Teacup.apply_hash appearance, properties.build, klass
      end
      styles.each do |klass, properties|
        appearance = klass.appearance
        Teacup.apply_hash appearance, properties.build, klass
      end
    end

  end

end
