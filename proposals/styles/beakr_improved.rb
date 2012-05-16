module Mystyle < ImageCaption
  include Teacup::Stylesheet

  layout do
    font = :'Proxima Nova'
  end

  images do
    # Size down images, add borders, etc.
  end

  type :caption do
    color = :gray
    font_size = 12
  end
end
