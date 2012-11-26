module Teacup
  module_function

  def dont_restyle?
    @dont_restyle ||= nil
  end

  def should_restyle?
    return ! self.dont_restyle?
  end

  def should_restyle_and_block
    should_restyle = self.should_restyle?
    @dont_restyle = true
    return should_restyle
  end

  def should_restyle! &block
    if block
      _dont_restyle = dont_restyle?
      @dont_restyle = nil
      yield
      @dont_restyle = _dont_restyle
    else
      @dont_restyle = nil
    end
  end

end
