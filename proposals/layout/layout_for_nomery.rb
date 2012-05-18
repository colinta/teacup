class CommuneViewController < UIViewController

  # A proposal for 'layout' that goes alongside my proposal for
  # stylsheets.
  #
  # There's a badly implemented version of it working on the Commune app,
  # https://github.com/ConradIrwin/Commune/tree/master/app/controllers/commune_view_controller.rb
  # 
  # The layout does two things, 1. constructs the UIViews in the necessary
  # order on viewDidLoad, and then calls layoutDidLoad. and 2. creates methods
  # to access all the created views.
  #
  # For convenience, it can also create an inline stylesheet (though actually
  # this behaviour may be rubbsih given how complicated the implementation of
  # style_sheet then becomes.
  #
  # TODO: This doesn't yet have facility to create subviews dynamically.
  #
  #
  layout :commune_view do
    subview :how_much
    subview :what_for
    subview :who_paid
    subview :who_participated
    subview :amount
    subview :event
    subview :commune_it
    subview :paid
    subview :participated
    # Look, you can nest stuff!
    subview :shiny_thing do
      # And you can put inline styles on stuff!
      subview :shadow_view, {
        top: 100,
        width: 100,
        height: 100,
        left: 550,
        backgroundColor: UIColor.blackColor
      } do
        subview :rounded_view, {
          class: UILabel,
          cornerRadius: 40,
          top: 10,
          left: 10,
          width: 80,
          height: 80,
          backgroundColor: UIColor.blueColor
        }
      end
    end
  end

  # Easy to switch style-sheets when the time comes.
  def willAnimateRotationToInterfaceOrientation(io, duration: duration)
    layout.style_sheet = style_sheet
  end

  def viewDidLoad
     # Take the declaration above and make lots of subviews!
     # we might want to put this somewhere central...
     self.layout = Teacup::Layout.new(view, style_sheet, self.class.layout_definition)

    # Woah, did you notice, I never assigned to these anywhere!!!
    amount.delegate = self
    event.delegate = self
    commune_it.addTarget(self, action: :click, forControlEvents:UIControlEventTouchUpInside)

    paid.people = Person::ALL
    participated.people = Person::ALL
  end
  
   # Eww, icky, yucky, eeww..
   # Maybe we should some how move the 'class's style_sheet more internally...
  def style_sheet
    super_sheet = self.class.style_sheet
    Teacup::StyleSheet.new(:Temp) do
      if UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeLeft ||
         UIDevice.currentDevice.orientation == UIDeviceOrientationLandscapeRight
        include Teacup::StyleSheet::IPad
      else
        include Teacup::StyleSheet::IPadVertical
      end
      include super_sheet
    end
  end
end
