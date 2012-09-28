
class FirstController < UIViewController

  stylesheet :first

  layout :root do
    subview(CustomView, :background) do
      @welcome = subview(UILabel, :welcome)
      subview(UILabel, :footer)
      @button = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :next_message)
=begin
      @label1 = subview(UILabel, text: "label1", height: 20, width: 100, position: :relative, margins: [0, 0, 10, 30])
      subview(UIView, height: 100, width: 320, position: :relative) do
        @label2 = subview(UILabel, text: "label2", height: 20, width: 100, position: :relative, margins: [10, 0, 10, 0])
        @label3 = subview(UILabel, text: "label3", height: 20, width: 100, position: :relative, display: :inline, margins: [10, 0, 10, 0])

        @label4 = subview(UILabel, text: "label4", x: 0, y: 0, width: 100, height: 20)
      end
=end
    end

    @button.addTarget(self, action: :next_message, forControlEvents:UIControlEventTouchUpInside)
  end

  def next_view
  end

  def next_message
    msg = messages.shift
    if msg
      @welcome.text = msg
    else
      @welcome.text = 'Next example...'

      @button.removeTarget(self, action: :next_view, forControlEvents:UIControlEventTouchUpInside)
      @button.addTarget(self, action: :next_view, forControlEvents:UIControlEventTouchUpInside)
    end
  end

  def messages
    @messages ||= [
      'This is teacup',
      'Welcome',
      'This is teacup',
      'Welcome to teacup',
      'You can do anything at teacup',
      'Anything at all',
      'The only limit is yourself ',
      'Welcome to teacup',
      'Welcome to teacup',
      'This is teacup',
      'Welcome to teacup',
      'This is teacup, Welcome',
      'Yes, this is teacup',
      'This is teacup and welcome to you who have come to teacup',
      'Anything is possible at teacup',
      'You can to anything teacup',
      'The infinite is possible at teacup',
      'The unattainable is unknown at teacup',
      'Welcome to teacup',
      'This is teacup',
      'Welcome to teacup',
      'Welcome',
      'This is teacup',
      'Welcome to teacup',
      'Welcome to teacup',
    ]
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end
