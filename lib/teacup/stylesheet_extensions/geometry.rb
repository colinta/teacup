module Teacup
  class Stylesheet
    def iPhone       ; 1 << 1 ; end
    def iPhoneRetina ; 1 << 2 ; end
    def iPhone5      ; 1 << 3 ; end
    def iPad         ; 1 << 4 ; end
    def iPadRetina   ; 1 << 5 ; end

    # returns the device size in points, regardless of status bar
    def screen_size
      UIScreen.mainScreen.bounds.size
    end

    # returns the application frame, which takes the status bar into account
    def app_size
      UIScreen.mainScreen.applicationFrame.size
    end

    # returns a bit-wise OR of the device masks
    def device
      this_device = 0
      if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
        this_device |= iPhone
        if UIScreen.mainScreen.respond_to? :scale
          this_device |= iPhoneRetina
          if UIScreen.mainScreen.bounds.size.height == 568
            this_device |= iPhone5
          end
        end
      else
        this_device |= iPad
        if UIScreen.mainScreen.respond_to? :scale
          this_device |= iPadRetina
        end
      end

      return this_device
    end

  end
end
