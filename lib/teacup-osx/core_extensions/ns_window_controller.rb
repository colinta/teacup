class NSWindowController
  include Teacup::Layout
  include Teacup::Controller

  def windowDidLoad
    teacupDidLoad
  end

  def top_level_view
    window.contentView
  end

end


class TeacupWindowController < NSWindowController

  def self.new
    alloc.initWithWindowNibName(self.class.name)
  end

  def loadWindow
    self.window = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
  end

end
