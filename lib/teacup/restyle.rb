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

  def should_restyle!
    @dont_restyle = nil
  end

end
