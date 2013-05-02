# Teacup's NSView extensions defines some utility functions for NSView that
# enable a lot of the magic for Teacup::Layout.
#
# Users of teacup should be able to ignore the contents of this file for
# the most part.
class NSView
  include Teacup::Layout
  include Teacup::View

  class << NSView
    attr :teacup_is_animating
  end

  def teacup_animation(options)
    NSAnimationContext.beginGrouping
    NSAnimationContext.currentContext.setDuration(options[:duration]) if options.key?(:duration)
    NSAnimationContext.currentContext.setTimingFunction(options[:timing]) if options.key?(:timing)
    NSView.teacup_is_animating = true
    yield
    NSView.teacup_is_animating = false
    NSAnimationContext.endGrouping
  end

  def apply_style_properties(properties)
    Teacup.apply_hash((NSView.teacup_is_animating ? self.animator : self), properties)
  end

  def style(properties)
    super

    self.setNeedsDisplay(true)
    self.setNeedsLayout(true)
  end

  def top_level_view
    self
  end

end
