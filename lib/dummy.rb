class DummyView < UIView
private
  def dummy
    setFrame(nil)
    setOpaque(nil)
  end
end

class DummyScrollView < UIScrollView
private
  def dummy
    setScrollEnabled(nil)
    setShowsHorizontalScrollIndicator(nil)
    setShowsVerticalScrollIndicator(nil)
  end
end

class DummyActivityIndicatorView < UIActivityIndicatorView
private
  def dummy
    setHidesWhenStopped(nil)
  end
end

class DummyLabel < UILabel
private
  def dummy
    setAdjustsFontSizeToFitWidth(nil)
  end
end

class DummyTextField < UITextField
private
  def dummy
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
