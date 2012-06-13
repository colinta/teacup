
class DummyView < UIView

  def dummy
    setFrame(nil)
  end

end

class DummyLayer < CALayer

  def dummy
    setCornerRadius(nil)
    setTransform(nil)
    setMasksToBounds(nil)
    setShadowOffset(nil)
  end

end
