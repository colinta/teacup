module Teacup
  class Limelight < Stylesheet
    attr :styles

    def initialize(&block)
      @styles = {}
      instance_exec(&block)
    end

    def method_missing(property, value=nil, &more_props)
      if more_props
        value = Limelight.new(&more_props).styles
      end
      styles[property] = value
    end

  end
end
