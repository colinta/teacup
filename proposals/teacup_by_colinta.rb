#
#  see http://colinta.com/thoughts/toolbar_teacup_and_me.html
#
#  #colinta

##|
##|  APP DELEGATOR
##|
def ipad?
  UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
end

Teacup::App do |application, options, window|
  if ipad?
    MyIpadController
  else
    MyIphoneController
  end
end

##|
##|  CREATE A TOOLBAR AND ADD IT TO YOUR VIEW
##|
toolbar = Teacup::Toolbar(
    frame: [[0, 416], [320, 44]],
    tint: [21, 78, 118].color,
  ) do
  # self refers to the newly created UIToolbar, so self.BarButtonItem will
  # know where to add the button
  toolbar_button = self.BarButtonItem(:refresh) { target.flipp }
end

self.view << toolbar


##|
##|  CoreGraphics ANIMATION
##|
def flipp
  # left_view_controller and right_view_controller are two views, this method
  # toggles between them.  @current points to one or the other.

  remove = @current

  if @current == left_view_controller
    current = right_view_controller
    transition = :curl_up
  else
    current = left_view_controller
    transition = :curl_down
  end

  @current = current

  Teacup::Animate(
      duration: 1.25,
      ease: :ease_in_out,
      transition: transition,
      view: self.view
    ) do
    # hmmm, not sure how I feel about THIS:
    hide remove
    show current, index: 0
    #     replaces:
    # remove.viewWillDisappear(true)
    # current.viewWillAppear(true)
    # remove.view.removeFromSuperview
    # self.view.insertSubview(current.view, atIndex:0)
    # remove.viewDidDisappear(true)
    # current.viewDidAppear(true)
  end
end


##|
##|  STYLES / STYLESHEETS
##|
framed_view = Teacup::Style do
  frame = [[0, 0], [320, 460]]
end

##|  inherit from another style
colored_view = Teacup::Style(framed_view) do
  status_bar = :black
  opacity = 0.5
end

class LeftViewController < UIViewController

  def viewDidLoad
    # include styles, and add some of our own
    Teacup::style(self.view) do
      import colored_view
      background_color = [0, 136, 14].color
    end
  end

end

class RightViewController < UIViewController

  def viewDidLoad
    Teacup::style(self.view) do
      import colored_view
      background_color = [0, 136, 14].color
    end
  end

end
