
class MyStyle < Teacup::Style
  labels do  # all UILabels
    color = :black
    font = :Inconsolata

    all :header do  # all UILabels of class "header"
      font_size = 20
    end

    the :main_label do  # the label with id "main_label"
      text = 'Welcome.  Welcome to Zombocom.'
      font_size = 30
      color = '#ffeeff'
      shadow =
    end
  end
end