class DummyView < NSView
private
  def dummy
    setFrame(nil)
    setOpaque(nil)
    setClipsToBounds(nil)
    setUserInteractionEnabled(nil)
    setAutoresizingMask(nil)
    NSView.appearanceWhenContainedIn(NSView, nil)
    NSView.appearance
  end
end

class DummyTableView < NSTableView
private
 def dummy
   setAllowSelection(value)
   setSelectionHighlightStyle(value)
 end
end

class DummyTableColumn < NSTableColumn
private
  def dummy
    setEditable(nil)
  end
end

class DummyButton < NSButton
private
  def dummy
    setTitleEdgeInsets(nil)
    setTarget(nil)
    setAction(nil)
    setBezelStyle(nil)
    setBordered(nil)
    setImagePosition(nil)
  end
end

class DummyScrollView < NSScrollView
private
  def dummy
    setScrollEnabled(nil)
    setHasVerticalScroller(nil)
    setHasHorizontalScroller(nil)
  end
end

class DummyTextField < NSTextField
private
  def dummy
    setAdjustsFontSizeToFitWidth(nil)
    setFormatter(nil)
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
