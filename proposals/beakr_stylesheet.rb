# - - - - - - - - - - - - - - - - - - -
# Proposal by Beakr
# Created at: 15 May, 2012
#
# May be improved later on through the
# applications development
# - - - - - - - - - - - - - - - - - - -


# - - - - - - - - - - - - - - - - - - -
# Style
# - - - - - - - - - - - - - - - - - - -

class UIStyle < Teacup::Style # or Teacup::Stylesheet
  
  # All blocks are prefixed with UI, so
  Label { ... }
  # Will affect UILabel, while
  TextField { ... }
  # Will affect UITextField

  # Sample styles
  Label do
    color = :black
    font  = 'Proxima Nova'

    # Made into `types` so we're not using the class keyword
    # Affects all UILabels with the type 'header'
    type :header do
      font_size = 20
      color     = :blue
    end

  end

  # Affect the whole layout of the app with
  Layout do
    background = :white
  end

end

# - - - - - - - - - - - - - - - - - - -
# Controller
# - - - - - - - - - - - - - - - - - - -

class SomeController < UIViewController
  def viewDidLoad
    # include Stylesheet
    Teacup::include(UIStyle)

    # create an object
    @label = Teacup::Label.type(:header).new
    @label.text = "I used a Teacup stylesheet!" # Inherits from both Label {...} and
                                                # header type.

    @standard = Teacup::Label.new # Just normal label not of the header type
    @standard.text = "A normal label."
  end
end
