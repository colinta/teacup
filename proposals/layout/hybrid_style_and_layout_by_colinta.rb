##|
##|  This is heavily inspired by farcaller & conradirwin's proposals. :-)
##|  I'm trying to bring the favorite features of both in, so we can start
##|  actually *building* this thing!
##|


###           **************************************
###           * |======| Title Goes here, bold     *
###           * | icon |                         > * <= accessory view
###           * |======| mm/dd/YYYY   more info    *  <= smaller, gray captions
###           **************************************

  ##|
  ##|  STYLE DECLARATIONS
  ##|  based on conradirwin's nom/domnomery
  ##|  I like the curlies, but they are optional
  ##|


# first, styles, broken out into a Stylesheet class
# I'm using blocks here, a hash could also be used,
# but the layout uses blocks, so point for consistency.
# this would be in its own file.
class MyStylesheet < Teacup::Style
  s.style :shadow { |s|
    shadow_color = :black.uicolor,
    shadow_offset = 3,
    shadow_radius = 1
  }

  style :icon { |s|
    s.extends :shadow
    s.margin = 2
  }

  s.style :title { |s|
    s.font = :bold.uifont(14)  # see [sugarcube](https://github.com/colinta/sugarcube)
  }

  s.style :info { |s|
    s.font = :small.uifont
    # non UIColor objects will be converted by calling `uicolor`, so as long as
    # sugarcube supports it, you're golden!
    s.font_color = :gray
  }

  s.style :date { |s|
    s.extends :info,
    s.align = :left.uialignment,
  }

  s.style :more_info { |s|
    s.extends :info,
    s.align = :right.uialignment,
    s.height = 20,
  }

  s.style :half_width { |s|
    s.width = 50.percent
  }

  s.style :full_width {|s|
    s.width = 100.percent
  }

  # I KNOW that accessory views are just an option on UITableCellView,
  # but it makes a good example for why you would use a "box" to contain
  # a few views, and then the button would be floated next to the box.
  s.style :accessory_image {|s|
    s.width = 10
    s.height = 10
    # the 'Percent' class will be special, so that we can do this kind of
    # trickery:
    s.margin_top = s.margin_bottom = 100.percent - 10
  }
end


# k, when we creat an image & text cell, we're gonna need these four properies:
# image, title, date, and more_info.  These get handed into some constructor,
# could be a factory, or hash:
#
#     cell = ImageAndTextCell.alloc.init {
#       title: 'My Title',
#       image: 'the_image.png',
#       date: '01/01/2012'
#       more_info: 'neat!'
#     }
#
#     cell = ImageAndTextCell.new {|v|
#       v.title = 'My Title'
#       v.image = 'the_image.png'
#       v.date = '01/01/2012
#       v.more_info = 'neat!'
#     }
#
# the bulk of the work is done in `layout do...end`.  This code would normally
# go in the ViewController, but that clutters the Controllers.  This encourages
# building *views* in separate files, and instantiating those from the
# controller (using code like above).
class ImageAndTextCell < UITableCellView
  include Teacup::View

  # declaring these properies here makes them
  # available as arguments to the constructor
  # and available as @properties in the layout.
  #
  # plus, the `synthesize` keyword is a Cocoa
  # staple, so Cocoa devs will immediately know
  # what is up.  of coure, `attr` is more rubyesque...
  #
  # it's up for debate, my vote goes to synthesize for now... :-|
  synthesize :image, :required => false
  synthesize :title
  synthesize :date, :required => false
  synthesize :more_info, :required => false  # or :default => 'something'

  ##|
  ##|  LAYOUT DECLARATION
  ##|  called in init, after initialization, to construct our views
  ##|
  layout do |layout|
    layout.height = 30

    if @image
      # ImageView is inherited from Teacup::View
      # uses shadow and icon styles
      image_view = ImageView do |v|
        # long hand, short hand (so you can use styles from other classes)
        v.styles = self.styles[shadow:], :icon
        v.image = @image.uiimage  # String to UIImage!?  see sugarcube
        v.float = :left  # this is the default, but i'm being verbose
        # image will be scaled to fit, so a 100x40 image will become 50x20
        v.width = 50
      end

      # HMMMM - binding changes!?
#     self.on :change_image do
#     self.on :change, :image do
#     self.on change(:image) do
      self.on :change, :image do |image|
        image_view.image = @image  # again, since this isn't a UIImage instance, `.uiimage` will get called on it.
        self.setNeedsDisplay
      end
      layout << image_view
    end

    layout << title_view = Label do |v|
      v.width = 100.percent  # if the icon is missing, this will be the entire width of the cell
      v.height = 30
      v.text = @title
      v.alignment = :center.uialignment  # returns UITextAlignmentCenter
    end
    # BINDING title change
    self.on :change, :title do |title|
      title_view.text = title
    end

    # that binding thing is cool, huh?  i think so anyway...
    # i can imagine instances where you need to monitor when *multiple*
    # properties change
    self.on :change, :title, :date do |title, date|
      title_view.text = title + date
    end
    # it would be great if only one change event got fired when setting
    #
    #     image_view.title = 'foo'
    #     image_view.date = 'foo'
    #
    # but you would have to wrap these somehow
    #
    #     image_view.begin_edit
    #     image_view.title = 'foo'
    #     image_view.date = 'foo'
    #     image_view.end_edit  # fires
    #
    # which is fine, just something to think about.

    # moving on - let's try and add a date and/or more_info
    if @date or @more_info
      # views are pretty expensive, so I'd prefer if this object "acted" like
      # a view, but actually just handled margins, floating, and such.
      layout << Box do |box|
        box.width = 100.percent - 10
        box.height = 100.percent

        # this is just a variable
        label_width = @date and @more_info ? :half_width : :full_width

        # date
        if @date
          # i'm gonna propose another style syntax here, just for fun.
          box << Label(:date, label_width) do |v|
            v.text = @date
          end
        end

        if @more_info
          # yet another way to declare the styles!  I dunno which one i like
          box << Label(styles:[:more_info, label_width]) do |v|
            v.text = @more_info
          end
        end
      end
    end

    layout << ImageView(:accessory_image) do |v|
      v.float = :right      # again, sugarcube will resolve these into the "correct type"
      v.image = 'arrow.png' # for us.  happy day for duck typing!  :-)
    end
  end

end
