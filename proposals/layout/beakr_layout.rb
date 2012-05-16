# This layout is based off of farcallers layout file, just containing my imrovements and ideas.
# Please see https://github.com/rubymotion/teacup/blob/master/proposals/layout/layout_by_farcaller.rb#L14
# for the original idea.

class MyCell < UITableViewCell
  include Teacup::Layout

  main_layout do
    default_size = [320, 60]

    # Layouts for different sections are declared using
    # different symbols or strings.

    # Teacup will do what it does to align your items in a certain way.

    # Define a layout for the right part of the devices screen:
    layout :right do
      # Use Teacup::Style to define styling for layout?
    end

    layout :top do
      height           = 10
      background_color = :white
      font             = :'Proxima Nova'
    end

  end
end
