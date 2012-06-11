
class FirstController < UIViewController

  stylesheet :first

  layout :root do
    subview(UIView, :background) do
      @welcome = subview(UILabel, :welcome)
      subview(UILabel, :footer)
      @button = subview(UIButton.buttonWithType(:rounded.uibuttontype), :next_message)
    end

    @button.on(:touch) do |event|
      msg = next_message
      puts msg, messages.length
      if msg
        @welcome.text = msg
      else
        @welcome.text = 'Next example...'
        @button.off(:touch)

        @button.on(:touch) do |event|
          next_view
        end
      end
    end
  end

  # used in testing
  def landscape_only
    UIApplication.sharedApplication.windows[0].rootViewController = LandscapeOnlyController.alloc.init
  end

  def next_view
    landscape_only
  end

  def next_message
    messages.shift
  end

  def messages
    @messages ||= [
      # 'This is teacup',
      # 'Welcome',
      # 'This is teacup',
      # 'Welcome to teacup',
      # 'You can do anything at teacup',
      # 'Anything at all',
      # 'The only limit is yourself ',
      # 'Welcome to teacup',
      # 'Welcome to teacup',
      # 'This is teacup',
      # 'Welcome to teacup',
      # 'This is teacup, Welcome',
      # 'Yes, this is teacup',
      # 'This is teacup and welcome to you who have come to teacup',
      # 'Anything is possible at teacup',
      # 'You can to anything teacup',
      # 'The infinite is possible at teacup',
      # 'The unattainable is unknown at teacup',
      # 'Welcome to teacup',
      # 'This is teacup',
      # 'Welcome to teacup',
      # 'Welcome',
      # 'This is teacup',
      # 'Welcome to teacup',
      # 'Welcome to teacup',
    ]
  end

  def shouldAutorotateToInterfaceOrientation(orientation)
    autorotateToOrientation(orientation)
  end

end
