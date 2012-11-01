# Teacup's UIView extensions defines some utility functions for UIView that
# enable a lot of the magic for Teacup::Layout.

# Users of teacup should be able to ignore the contents of this file for
# the most part.
class UIView
  include Teacup::Layout

  MAX_SIZE = 9999
  MAX_DIMENSION = [0, MAX_SIZE]
  MAX_DIMENSIONS = [MAX_DIMENSION, MAX_DIMENSION]

  # The current stylename that is used to look up properties in the stylesheet.
  attr_reader :stylename

  # position: absolute or relative
  attr_accessor :position

  # display: inline, block, none
  attr_accessor :display

  LEFT = 0
  RIGHT = 1
  TOP = 2
  BOTTOM = 3

  # four part array with margins in it
  attr_accessor :margins

  # four part array with borders in it
  attr_accessor :paddings

  # min and max widths
  attr_accessor :min_width
  attr_accessor :max_width

  # min and max heights
  attr_accessor :min_height
  attr_accessor :max_height

  # Enable debug messages for this object
  attr_accessor :debug

  # The current stylesheet will be looked at when properties are needed.  It
  # is loaded lazily, so that assignment can occur before the Stylesheet has
  # been created.
  def stylesheet
    if @stylesheet.is_a? Symbol
      @stylesheet = Teacup::Stylesheet[@stylesheet]
    end

    @stylesheet
  end

  # Alter the stylename of this view.
  #
  # This will cause new styles to be applied from the stylesheet.
  #
  # @param Symbol  stylename
  def stylename=(new_stylename)
    @stylename = new_stylename
    restyle! if Teacup.should_restyle?
  end

  # Alter the stylesheet of this view.
  #
  # This will cause new styles to be applied using the current stylename,
  # and will recurse into subviews.
  #
  # If you would prefer that a given UIView object does not inherit the
  # stylesheet from its parents, override the 'stylesheet' method to
  # return the correct value at all times.
  #
  # @param Teacup::Stylesheet  stylesheet.
  def stylesheet=(new_stylesheet)
    should_restyle = Teacup.should_restyle_and_block

    @stylesheet = new_stylesheet
    subviews.each{ |subview| subview.set_stylesheet_quickly(new_stylesheet) }

    if should_restyle
      restyle!
      Teacup.should_restyle!
    end
  end

  def position
    @position || :absolute 
  end
  
  def display
    @display || :block
  end

  def margins
    @margins || [0,0,0,0]
  end

  def margin_right
    margins[RIGHT]
  end

  def margin_left
    margins[LEFT]
  end

  def margin_top
    margins[TOP]
  end

  def margin_bottom
    margins[BOTTOM]
  end

  def dimensions=(size)
    if size[0].is_a?(Array)
      @min_width = width = size[0][0]
      @max_width = size[0][1]
    else
      width = size[0]
    end
 
    if size[1].is_a?(Array)
      @min_height = height = size[1][0]
      @max_height = size[1][1]
    else
      height = size[1]
    end
 
    self.frame = [[0,0],[width, height]]
  end

  def horz_stretchable?
    @min_width != @max_width
  end

  def min_width
    @min_width || self.bounds.size.width
  end

  def max_width
    @max_width || self.bounds.size.width
  end

  def vert_stretchable?
    @min_height != @max_height
  end

  def min_height
    @min_height || self.bounds.size.height
  end

  def max_height
    @max_height || self.bounds.size.height
  end

  def set_stylesheet_quickly(new_stylesheet)
    @stylesheet = new_stylesheet
    subviews.each{ |subview| subview.set_stylesheet_quickly(new_stylesheet) }
  end

  def restyle!(orientation=nil)
    if Teacup.should_restyle?
      if stylesheet
        style(stylesheet.query(stylename, self, orientation))
      end
      subviews.each{ |subview| subview.restyle!(orientation) }
    end
  end

  # Animate a change to a new stylename.
  #
  # This is equivalent to wrapping a call to .stylename= inside
  # UIView.beginAnimations.
  #
  # @param Symbol  the new stylename
  # @param Options  the options for the animation (may include the
  #                 duration and the curve)
  #
  def animate_to_stylename(stylename, options={})
    return if self.stylename == stylename

    UIView.beginAnimations(nil, context: nil)
    # TODO: This should be in a style-sheet!
    UIView.setAnimationDuration(options[:duration]) if options[:duration]
    UIView.setAnimationCurve(options[:curve]) if options[:curve]
    self.stylename = stylename
    UIView.commitAnimations
  end

  # Animate a change to new styles
  #
  # This is equivalent to wrapping a call to .style() inside
  # UIView.beginAnimations.
  #
  # @param Hash   the new styles and options for the animation
  #
  def animate_to_style(style)
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(style[:duration]) if style[:duration]
    UIView.setAnimationCurve(style[:curve]) if style[:curve]
    style(style)
    UIView.commitAnimations
  end

  # Apply style properties to this element.
  #
  # Takes a hash of properties such as may have been read from a stylesheet
  # or passed as parameters to {Teacup::Layout#layout}, and applies them to
  # the element.
  #
  # Does a little bit of magic (that may be split out as 'sugarcube') to
  # make properties work as you'd expect.
  #
  # If you try and assign something in properties that is not supported,
  # a warning message will be emitted.
  #
  # @param Hash  the properties to set.
  def style(properties, orientation=nil)
    Teacup.apply_hash self, properties
    properties.each do |key, value|
      Teacup.apply self, key, value
    end

    self.setNeedsDisplay
    self.setNeedsLayout
  end

  def top_level_view
    return self
  end

end
