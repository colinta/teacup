# Teacup's UIView extensions defines some utility functions for UIView that
# enable a lot of the magic for Teacup::Layout.
#
# Users of teacup should be able to ignore the contents of this file for
# the most part.
class UIView
  include Teacup::Layout
  include Teacup::View

  def teacup_animation(options)
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(options[:duration]) if options.key?(:duration)
    UIView.setAnimationCurve(options[:curve]) if options.key?(:curve)
    UIView.setAnimationDelay(options[:delay]) if options.key?(:delay)
    yield
    UIView.commitAnimations
  end

  def style(properties)
    super

    self.setNeedsDisplay
    self.setNeedsLayout
  end

  def top_level_view
    self
  end

end
