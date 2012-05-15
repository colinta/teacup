#
#  Incomplete, and subject to change.  I don't particularly
#  like it right now :-/
#
#  #colinta


# inherit from Style; "sets up" the style DSL
class MyStyle < Teacup::Style

  Label do  # all UILabels
    color = :black
    font = :Inconsolata

    # all UILabels of class "header"
    header do
      font_size = 20
      shadow = :black
    end
  end

  Layout do

end


class MyAppController < UIViewController

  def viewDidLoad
    # objects created here will use MyStyle
    Teacup::use(MyStyle)
    # create by "id"
    @label = Teacup::Label.header.new()
    @label.text = 'My Project'

    @header = Teacup::Label.header.new()
    @header.text = 'Header'

    @generic = Teacup::Label.new()
    @generic.text = 'another label'


  end