# Teacup's NSWindow extensions defines some utility functions for NSWindow that
# enable a lot of the magic for Teacup::Layout.
#
# Users of teacup should be able to ignore the contents of this file for the
# most part.
class NSWindow
  include Teacup::Layout
  include Teacup::View

  class << NSWindow
    attr :teacup_is_animating
  end

  def teacup_animation(options)
    NSAnimationContext.beginGrouping
    NSAnimationContext.currentContext.setDuration(options[:duration]) if options.key?(:duration)
    NSAnimationContext.currentContext.setTimingFunction(options[:timing]) if options.key?(:timing)
    NSWindow.teacup_is_animating = true
    yield
    NSWindow.teacup_is_animating = false
    NSAnimationContext.endGrouping
  end

  def apply_style_properties(properties)
    Teacup.apply_hash((NSWindow.teacup_is_animating ? self.animator : self), properties)
  end

  def style(properties)
    super

    self.setNeedsDisplay(true)
    self.setNeedsLayout(true)
  end

  def top_level_view
    contentView
  end

end
