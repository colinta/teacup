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

    def build(target=nil, orientation=nil, seen={})
      properties = Style.new.update(self)
      properties.stylename = self.stylename
      properties.stylesheet = self.stylesheet

      # at this point, we really DO need the orientation
      orientation = UIDevice.currentDevice.orientation unless orientation

      # first, move orientation settings into properties "base" level.
      if orientation
        Overrides[orientation].each do |orientation_key|
          if override = properties.delete(orientation_key)
            # override is first, so it takes precedence
            if override.is_a? Hash
              Teacup::merge_defaults override, properties, properties
            elsif not properties.has_key? orientation_key
              properties[orientation_key] = override
            end
            properties.supports[orientation_key] = properties[orientation_key] ? true : false
          end
        end
      end

      # delete all of them from `properties`
      Orientations.each do |orientation_key|
        if properties.delete(orientation_key)
          properties.supports[orientation_key] = true
        end
      end

      # now we can merge extends, and importing.  before merging, these will go
      # through the same process that we just finished on the local style
      if stylesheet
        stylesheet.imported_stylesheets.reverse.each do |stylesheet|
          imported_properties = stylesheet.query(self.stylename, target, orientation, seen)
          Teacup::merge_defaults! properties, imported_properties
        end

        if also_includes = properties.delete(:extends)
          also_includes = [also_includes] unless also_includes.is_a? Array

          # turn style names into Hashes by querying them on the stylesheet
          # (this does not pass `seen`, because this is a new query)
          also_includes.each do |also_include|
            extended_properties = stylesheet.query(also_include, target, orientation)
            Teacup::merge_defaults! properties, extended_properties
          end
        end

        # if we know the class of the target, we can apply styles via class
        # inheritance.  We do not pass `target` in this case.
        if target
          target.class.ancestors.each do |ancestor|
            extended_properties = stylesheet.query(ancestor, nil, orientation)
            Teacup::merge_defaults!(properties, extended_properties)
          end
        end
      end

      properties
    end

  end
end
