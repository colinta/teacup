class DummyView < UIView
private
  def dummy
    setFrame(nil)
    setOpaque(nil)
    setClipsToBounds(nil)
    setUserInteractionEnabled(nil)
    UIView.appearanceWhenContainedIn(UIView, nil)
    UIView.appearance
  end
end

class DummyTableView < UITableView
private
 def dummy
   setAllowSelection(value)
 end
end

class DummyButton < UIButton
private
  def dummy
    setTitleEdgeInsets(nil)
  end
end

class DummyScrollView < UIScrollView
private
  def dummy
    setPagingEnabled(nil)
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
    setSecureTextEntry(nil)
    setReturnKeyType(nil)
    setAutocapitalizationType(nil)
    setAutocorrectionType(nil)
    setSpellCheckingType(nil)
  end
end

class DummyPickerView < UIPickerView
private
  def dummy
    setShowsSelectionIndicator(nil)
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

class DummySwitch < UISwitch
private
  def dummy
    on?
    setOn(true)
  end
end

