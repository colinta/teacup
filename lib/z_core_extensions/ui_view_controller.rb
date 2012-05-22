class UIViewController
  include Teacup::Layout

  class << self
    def interface(name, properties={}, &block)
      @interface_definition = @interface_definition = [name, properties, block]
    end

    def interface_definition
      @interface_definition
    end
  end

  def viewDidLoad
    if self.class.interface_definition
      name, properties, block = self.class.interface_definition
      layout(view, name, properties, &block)
    end

    layoutDidLoad
  end

  def layoutDidLoad; true; end
end
