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

##| k, we're gonna need four properies when we instantiate a new
##| ImageAndTextCell: image, title, date, and more_info
##|
##| that's my first big change from farcaller and conradirwin.

class ImageAndTextCell < UITableCell
  include Teacup::View

  # declaring these properies here makes them
  # available as arguments to the constructor
  # and available as @property in the layout
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
  ##|  STYLE DECLARATIONS
  ##|  based on conradirwin's nom/domnomery
  ##|  I like the curlies, but they are optional
  ##|
  styles do |s|
    s.style :icon, {
      margin: 2
    }

    s.style :shadow, {
      shadow_color: :black.uicolor,
      shadow_offset: 3,
      shadow_radius: 1
    }

    s.style :title, {
      font: :bold.uifont(14)  # see sugarcube
    }

    s.style :info, {
      font: :system.uifont(8)
    }

    s.style :date, {
      like: :info,
      align: :left.uialignment,
    }

    s.style :more_info, {
      like: :info,
      align: :right.uialignment,
      height: 20,
    }

    s.style :half_width, {
      width: 50.percent
    }

    ##|  another way to do them would be to use a block:
    s.style :full_width {|s|
      s.width = 100.percent
    }
    s.style :accessory_image {|s|
      s.width = 10
      s.height = 10
      # the 'Percent' class will be special, so that we can do this kind of
      # trickery:
      s.margin_top = s.margin_bottom = 100.percent - 10
    }
    ##|  I think I like the block syntax a little more... consistent
    ##|  with the layout declaration below
  end


  ##|
  ##|  LAYOUT DECLARATION
  ##|  called in init to construct our views?
  ##|  called manually, returning a new view?
  ##|
  layout do |layout|
    layout.height = 30

    if @image
      # ImageView is inherited from Teacup::View
      # uses shadow and icon styles
      layout << ImageView do |v|
        # long hand, short hand (so you can use styles from other classes)
        v.styles = self.styles[shadow:], :icon
        v.image = @image.uiimage  # String to UIImage!?  see sugarcube
        v.float = :left  # this is the default, but i'm being verbose
        # image will be scaled to fit, so a 100x40 image will become 50x20
        v.width = 50
      end
    end

    layout << Label do |v|
      v.width = 100.percent  # if the icon is missing, this will be the entire width of the cell
      v.height = 30
      v.text = @title
      v.alignment = :center.uialignment  # returns UITextAlignmentCenter
    end

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

    self << ImageView(:accessory_image) do |v|
      v.image = 'arrow.png'.uiimage
    end
  end

end
