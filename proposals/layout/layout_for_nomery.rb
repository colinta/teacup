# A proposal that tries to take the best of the previous nomery proposal,
# without the objectionable magic; to end up somewhere close to colinta's
# teacup proposal.
#
# Description of APIs:
#
#   UIViewController.layout(style_name, &block) can be used to declare the
#   layout of this controller. The style_name is added to the 'view', and
#   the block is instance_exec'd in viewDidLoad (after which layoutDidLoad
#   is called).
#
#   Teacup::Layout#layout(class_or_instance, style_name, style_properties, &block)
#   (aka. UIViewController#layout,  UIView#layout) can be used to fix up the
#   layout.
#
#   It apples the style_name and style_properties to the instance (creating a new
#   instance if a class was passed), and then adds this instance to the current view.
#
#   If the block is passed it is called, and any calls to "layout" within the block
#   will add further subviews to the newly styled view.
#
#   UIView#style_name, UIView#style_sheet
#   These are attr_accessor, and when you change them the view's style is recomputed.
#
#   UIViewController#style_sheet
#   The user must implement this function to determine the current stylesheet.
#
# Main differences from colinta's version:
#
# 1. The nesting is done automatically by block inclusion.
#   e.g. to add a new subview to 'foo':
#
#      layout(foo) do
#        layout(UIView.new, :subview)
#      end
#
#   this is because you otherwise end up with lots of view << foo = bar,
#   which is very ugly
#
# 2. Instead of using upper-case-methods as constructors, use a layout()
#    function that accepts a class. This works better with people's custom
#    UIView sub-classes and feels less magic.
#
# 3. Instead of using 'synthesise' to push variables into the layout; just
#    evaluate the layout in the context of the controller. Then people can
#    use attr_accessor as normal.
#
# Main difference from the original:
#
# 1. Doesn't automatically create view objects or assign them to controller
#    attributes; you have to be explicit about it. Feels much less magic.
#
# 2. Stores pointers from the UIView objects back to the style_sheet so that
#    changing style_name on a view causes a view recalculation.
#
# 3. Evals the layout in the controller, so you can set properties like
#    delegate there to real objects.
#
# 4. Makes 'layout' available for UIViews as well for homogenity.
#
class CommuneViewController < UIViewController

  attr_accessor :amount, :event, :commune_it, :paid, :participated

  layout(:commune_view) do |view|
    layout(UILabel, :how_much)
    layout(UILabel, :what_for)
    layout(UILabel, :who_paid)
    layout(UILabel, :who_participated)

    self.amount = layout(UITextField, :amount, delegate: self)
    self.event = layout(UITextField, :event, delegate: self)

    self.commune_it = layout(UIButton.buttonWithType(UIButtonTypeCustom), :commune_it)
    commune_it.addTarget(self, action: :click, forControlEvents:UIControlEventTouchUpInside)

    self.paid = layout(PersonList::SelectOne, :paid, people: Person::ALL)
    self.participated = layout(PersonList::SelectMany, :participated, people: Person::ALL)

    layout(UIView,
              top: 100,
              width: 100,
              height: 100,
              left: 550,
              backgroundColor: UIColor.blackColor
            ) do |shiny_thing|
              layout(UIView,
                cornerRadius: 30,
                top: 10,
                left: 10,
                width: 80,
                height: 80,
                backgroundColor: UIColor.blueColor
              )
            end
  end

  def style_sheet
    if [UIDeviceOrientationLandscapeLeft,
        UIDeviceOrientationLandscapeRight].include?(UIDevice.currentDevice.orientation)
      Teacup::StyleSheet::IPad
    else
      Teacup::StyleSheet::IPadVertical
    end
  end

  def textFieldShouldReturn(textField)
    if textField == amount
      event.becomeFirstResponder
    else
      event.resignFirstResponder
    end
  end

  def click
    form = Form.new(amount.text, @paid.selection, @participated.selection, event.text)
    return alert(form.validation_errors.join(", ")) unless form.valid?

    response = form.submit!

    if response =~ /Your response has been recorded./
      alert('w00t!, response recorded!');
    else
      $stderr.puts response
      alert('ZOMG, it didn"t work :(');
    end
  end

  def shouldAutorotateToInterfaceOrientation(io)
    true
  end

  def willAnimateRotationToInterfaceOrientation(io, duration: duration)
    restyle!
  end

  def alert(msg)
    alert = UIAlertView.new
    alert.title = "Commune!"
    alert.message = msg
    alert.addButtonWithTitle("OK")
    alert.show
  end
end
