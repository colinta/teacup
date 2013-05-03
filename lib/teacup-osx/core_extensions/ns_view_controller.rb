class NSViewController
  include Teacup::Layout
  include Teacup::Controller

  alias _teacup_loadview loadView
  def loadView
    if nibName and nibBundle
      _teacup_loadview
    else
      self.view = NSView.new
      self.view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable
    end

    teacupDidLoad
  end

  def top_level_view
    view
  end

end
