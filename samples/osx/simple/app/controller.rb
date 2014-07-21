class MainTableController < NSViewController

  def teacup_layout
    subview(NSImageView,
      frame: root.bounds,
      image: NSImage.imageNamed('teacup'),
      autoresizingMask: NSViewWidthSizable | NSViewHeightSizable,
      )
  end

end
