class MainController < UIViewController
  attr :welcome
  attr :button

  stylesheet :main

  def teacup_layout
    root :root
    subview(CustomView, :background) do
      @welcome = subview(UILabel, :welcome)
      subview(UILabel, :footer)
      @button = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :next_message)
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
