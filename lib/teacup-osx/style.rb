# Fixes here should be copied to teacup-ios/style.rb
module Teacup
  # The Style class is where the precedence rules are applied.  A Style can
  # query the Stylesheet that created it to look up other styles (for
  # `extends:`) and to import other Stylesheets.
  class Style < Hash
    attr_accessor :stylename
    attr_accessor :stylesheet

    # orientation is completely ignored on OS X, but the Teacup code was written
    # to support them, and it was easier to ignore the orientation system than
    # refactor it out of the shared code base.
    def build(target_class=nil, rotation_orientation=nil, seen={})
      properties = Style.new
      properties.stylename = self.stylename
      properties.stylesheet = self.stylesheet

      delete_keys = []
      properties.update(self)
      orientation = nil

      # now we can merge extends, and imported_stylesheets.  before merging,
      # these will go through the same process that we just finished on the
      # local style
      if stylesheet && stylesheet.is_a?(Teacup::Stylesheet)
        stylesheet.imported_stylesheets.reverse.each do |stylesheet|
          imported_properties = stylesheet.query(self.stylename, target_class, rotation_orientation, seen)
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
            extended_properties = stylesheet.query(also_include, target_class, rotation_orientation)
            delete_keys.each do |key|
              extended_properties.delete(key)
            end
            Teacup::merge_defaults! properties, extended_properties
          end
        end
        properties.delete(:extends)

        # if we know the class of the target_class, we can apply styles via class
        # inheritance.  We do not pass `target_class` in this case.
        if target_class
          unless target_class.is_a?(Class)
            target_class = target_class.class
          end

          target_class.ancestors.each do |ancestor|
            extended_properties = stylesheet.query(ancestor, nil, rotation_orientation)
            Teacup::merge_defaults!(properties, extended_properties)
          end
        end
      end

      return properties
    end

  end
end
