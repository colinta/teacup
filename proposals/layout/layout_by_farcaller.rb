# The layout idea is based on beakr_stylesheet.rb, please see that file first.

class InfoLabelStyle < Teacup::Style
  textColor = :dark_gray
end

class MyCell < UITableViewCell
  include Teacup::Layout
  
  # see the reference cell at http://cl.ly/272R0h1A1t0V3e3s0j2c
  layout do |l|
    # sets up the base size of the view for later calculations
    l.default_size = [320, 60]
    
    # layout the whole :left part of the view:
    #
    # ******************
    # *XXXX*           *
    # *XXXX*           *
    # ******************
    #
    # The width must be specified, the height is set to be equal to the view
    # height. This implies autoresizing of flexible height and right margin.
    # Second argument is a view class, third is an alias (see later)
    l.layout_left, UIImageView, :episode_image do |i|
      i.width = 96
    end
    
    # Layout the remaining part
    l.layout_right do
      # the right part is spilt into top / bottom layout
      
      # top part is a label with offsets. It still autolayouts as flexible width / bottom margin
      #
      # ******************
      # *XXXX* TTTTTTTTT *
      # *XXXX*           *
      # ******************
      l.layout_top, UILabel, :title do |i|
        i.offsets left: 7, right: 7
        
        i.style do |s|
          s.font = UIFont.boldSystemFontOfSize(14)
        end
      end
      
      l.layout_bottom do
        # ******************
        # *XXXX* TTTTTTTTT *
        # *XXXX* LL        *
        # ******************
        l.layout_left, UILabel, :length do |i|
          i.width = 52
          i.offsets left: 7, top: 10
          i.autoresize = flexible(:top_margin, :right_margin) # override the default autoresize rules for layout_left
          
          # you either define the style in a block
          i.style do |s|
            s.textColor = :dark_gray # use the common aliases from IB / UIColor
          end
        end
        
        # ******************
        # *XXXX* TTTTTTTTT *
        # *XXXX* LL   DDDD *
        # ******************
        l.layout_right, UILabel, :timestamp do |i|
          i.width = 78
          i.offsets right: 7, top: 10
          i.autoresize = flexible(:top_margin, :left_margin) # override the default autoresize rules for layout_right
          
          # or set the styling class
          i.style = InfoLabelStyle
        end
      end
    end
    
    # Note that layout_* don't create additional views in the hierarchy, they just
    # simplify frame calculations for relative elements.
  end
  
  def episode=(episode)
    # use the method l that is provided by Layout to access subviews by aliases.
    l.episode_image.image = episode.image
    l.title.text = episode.title
    l.length.text = episode.length.to_mm_ss
    l.timestamp.text = episode.timestamp.to_dfs(:medium)
  end
end

