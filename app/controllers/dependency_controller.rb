class DependencyController < UIViewController
  attr :button

  stylesheet :dependency

  def teacup_layout
    @button = subview(UILabel, :my_button)
  end

end


Teacup::Stylesheet.new :dependency do

  style :button,
    size: [90, 90],
    backgroundColor: UIColor.redColor

  style :my_button, extends: :button,
    top: 0,
    center_x: 80, # <-- This results in a frame of [[80, 0], [90, 90]] instead of [[35, 0], [90, 90]]
    text: 'My Button'

end
