class MainTableController < NSViewController

  layout do |root|
    subview(NSImageView,
      frame: root.bounds,
      image: NSImage.imageNamed('teacup'),
      autoresizingMask: NSViewWidthSizable | NSViewHeightSizable,
      )
  end

end
