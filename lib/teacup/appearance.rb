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

    # disable the stylesheet 'name' parameter, and assign the "super secret"
    # stylesheet name
    def initialize(&block)
      NSNotificationCenter.defaultCenter.addObserver(self,
              selector: :'apply_appearance:',
              name: UIApplicationDidFinishLaunchingNotification,
              object: nil)

      super(&block)
    end

    def apply_appearance(notification=nil)
      run_block
      styles.each do |klass, properties|
        contained_in = properties.delete(:when_contained_in)
        if contained_in
          contained_in = [contained_in] unless contained_in.is_a?(NSArray)
          # make a copy and add nil to the end
          contained_in += [nil]
          appearance = klass.send(:'appearanceWhenContainedIn:', *contained_in)
        else
          appearance = klass.appearance
        end

        Teacup.apply_hash appearance, properties.build
      end
    end

  end

end
