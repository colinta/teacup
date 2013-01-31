module Teacup
  # The Style class is where the precedence rules are applied.  A Style can
  # query the Stylesheet that created it to look up other styles (for
  # `extends:`) and to import other Stylesheets.  If it is handed a target (e.g.
  # a `UIView` instance) and orientation, it will merge those in appropriately
  # as well.
  class Style < Hash
    attr_accessor :stylename
    attr_accessor :stylesheet

    Orientations = [:portrait, :upside_up, :upside_down, :landscape, :landscape_left, :landscape_right]
    Overrides = {
      0 => [:portrait, :upside_up],
      UIInterfaceOrientationPortrait => [:portrait, :upside_up],
      UIInterfaceOrientationPortraitUpsideDown => [:portrait, :upside_down],
      UIInterfaceOrientationLandscapeLeft => [:landscape, :landscape_left],
      UIInterfaceOrientationLandscapeRight => [:landscape, :landscape_right],
    }

    # A hash of orientation => true/false.  true means the orientation is
    # supported.
    def supports
      @supports ||= {}
    end

    # returns the value - `nil` has special meaning when querying :portrait or :upside_up
    def supports? orientation_key
      supports[orientation_key]
    end

    def build(target=nil, rotation_orientation=nil, seen={})
      properties = Style.new
      properties.stylename = self.stylename
      properties.stylesheet = self.stylesheet

      # if we have an orientation, only apply those styles.  otherwise apply the
      # entire style, including the current orientation.
      if rotation_orientation
        # in order to preserve the "local-first" override, we need to *delete*
        # the keys in imported_stylesheets and extended_properties that are
        # present in this style - even though we don't ultimately *apply* the
        # styles
        delete_keys = self.keys
        orientation = rotation_orientation
      else
        delete_keys = []
        properties.update(self)
        orientation = UIApplication.sharedApplication.statusBarOrientation
      end

      # first, move orientation settings into properties "base" level.
      if orientation
        Overrides[orientation].each do |orientation_key|
          if override = self[orientation_key]
            # override is first, so it takes precedence
            if override.is_a? Hash
              Teacup::merge_defaults override, properties, properties
            end
          end
        end
      end

      # delete all of them from `properties`
      Orientations.each do |orientation_key|
        if self[orientation_key]
          properties.supports[orientation_key] = true
        end
        properties.delete(orientation_key)
      end

      # now we can merge extends, and importing.  before merging, these will go
      # through the same process that we just finished on the local style
      if stylesheet && stylesheet.is_a?(Teacup::Stylesheet)
        stylesheet.imported_stylesheets.reverse.each do |stylesheet|
          imported_properties = stylesheet.query(self.stylename, target, rotation_orientation, seen)
          delete_keys.each do |key|
            imported_properties.delete(key)
          end
          Teacup::merge_defaults! properties, imported_properties
        end

        if also_includes = self[:extends]
          also_includes = [also_includes] unless also_includes.is_a? Array

          # turn style names into Hashes by querying them on the stylesheet
          # (this does not pass `seen`, because this is a new query)
          also_includes.each do |also_include|
            extended_properties = stylesheet.query(also_include, target, rotation_orientation)
            delete_keys.each do |key|
              extended_properties.delete(key)
            end
            Teacup::merge_defaults! properties, extended_properties
          end
        end
        properties.delete(:extends)

        # if we know the class of the target, we can apply styles via class
        # inheritance.  We do not pass `target` in this case.
        if target
          target.class.ancestors.each do |ancestor|
            extended_properties = stylesheet.query(ancestor, nil, rotation_orientation)
            Teacup::merge_defaults!(properties, extended_properties)
          end
        end
      end

      properties
    end

  end
end
