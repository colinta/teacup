class DummyView < NSView
private
  def dummy
    setFrame(nil)
    setOpaque(nil)
    setClipsToBounds(nil)
    setUserInteractionEnabled(nil)
    NSView.appearanceWhenContainedIn(NSView, nil)
    NSView.appearance
  end
end

class DummyTableView < NSTableView
private
 def dummy
   setAllowSelection(value)
 end
end

class DummyButton < NSButton
private
  def dummy
    setTitleEdgeInsets(nil)
  end
end

class DummyScrollView < NSScrollView
private
  def dummy
    setScrollEnabled(nil)
    setShowsHorizontalScrollIndicator(nil)
    setShowsVerticalScrollIndicator(nil)
  end
end

class DummyTextField < NSTextField
private
  def dummy
    setAdjustsFontSizeToFitWidth(nil)
  end
end

class DummyTextView < NSTextView
private
  def dummy
    setSecureTextEntry(nil)
    setReturnKeyType(nil)
    setAutocapitalizationType(nil)
    setAutocorrectionType(nil)
    setSpellCheckingType(nil)
  end
end

class DummyLayer < CALayer
private
  def dummy
    setCornerRadius(nil)
    setTransform(nil)
    setMasksToBounds(nil)
    setShadowOffset(nil)
    setShadowOpacity(nil)
    setShadowRadius(nil)
    setShadowOffset(nil)
    setShadowColor(nil)
    setShadowPath(nil)
    setOpaque(nil)
    setTranslucent(nil)
  end
end
