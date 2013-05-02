class NSWindowController
  include Teacup::Layout
  include Teacup::Controller

  def windowDidLoad
    NSLog("=============== ns_window_controller.rb line #{__LINE__} ===============")
    teacupDidLoad
  end

  def top_level_view
    window.contentView
  end

end
