
module Teacup

  class Style < Hash
    def initialize(*args, &block)
      super
      instance_eval &block
    end

    def method_missing(name, *args, &block)
      if block_given?
        self[name] = Teacup::Style.new(*args, &block)
      else
        self[name] = args.shift
      end
    end
  end

end
