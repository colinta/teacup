
class DummyView < UIView

  def dummy
    setFrame(nil)
    setOpaque(nil)
  end

end

class DummyScrollView < UIScrollView

  def dummy
    setScrollEnabled(nil)
  end

end

class DummyLayer < CALayer

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
  end

end
