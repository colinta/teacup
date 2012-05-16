# This is my own improved version of by original beakr_style, and beakr_layout.

class ImageCaption < UITableViewCell  # I don't really care if this makes sense, I
                                      # haven't done much iOS.
  
  include Teacup::Layout
  include MyStyle # Import stylesheet to layout

  layout :right do
    add_image :icon
  end

  layout :top do
    label "Title"
  end

  layout :bottom_left do

    type :caption do
      label "mm/dd/yyyy"
    end

  end

  layout :bottom_right do

    type :caption do
      label "More info"
    end

  end

end
