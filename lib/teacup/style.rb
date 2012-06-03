
module Teacup
  class Style < Hash
    def initialize(*args, &block)
      super
      instance_eval &block
    end

    def method_missing(name, *args)
      self[name] = args.shift
    end
  end
end
