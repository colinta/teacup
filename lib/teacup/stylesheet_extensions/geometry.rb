# Example:
#     Teacup::Stylesheet.new :main do
#       style :root,
#         origin: [0, 0]
#
#       # device returns a bitmask of devices,
#       # device? expects a device bitmask, and returns true if it is present in
#       # device (the conditions below are equivalent)
#       if 0 < device & iPhone || device? iPhone
#         style :root, width: 320
#
#         if 0 < device & iPhone5 || device? iPhone5
#           style :root, height: 548
#         elsif 0 < device & iPhone || device? iPhone
#           style :root, height: 460
#         end
#       elsif 0 < device & iPad || device? iPad
#         style :root,
#           width: 768,
#           height: 1004
#       end
#
#       # that's a mess!  and this does the same thing anyway:
#       style :root,
#         frame: [[0, 0], app_size]
#     end
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
      @@this_device ||= nil
      return @@this_device if @@this_device

      @@this_device = 0
      if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone
        @@this_device |= iPhone
        if UIScreen.mainScreen.respond_to? :scale
          @@this_device |= iPhoneRetina
          if UIScreen.mainScreen.bounds.size.height == 568
            @@this_device |= iPhone5
          end
        end
      else
        @@this_device |= iPad
        if UIScreen.mainScreen.respond_to? :scale
          @@this_device |= iPadRetina
        end
      end

      return @@this_device
    end

    def device_is?(this_device)
      this_device = self.send(this_device) if this_device.is_a? Symbol
      return device & this_device > 0
    end

  end
end
