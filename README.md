Teacup
======

A community-driven DSL for creating user interfaces on iOS and OS X.

[![Build Status](https://travis-ci.org/rubymotion/teacup.png)](https://travis-ci.org/rubymotion/teacup)

Using Teacup, you can create and style layouts and keeping your code dry.  The
goal is to offer a rubyesque (well, actually a rubymotion-esque) way to create
interfaces programmatically.

**Check out some sample apps!**

* iOS
  * [Hai][Hai]
  * [AutoLayout][AutoLayout]
  * [Sweettea Example][sweettea-example]
* OS X
  * [Tweets][Tweets] - ported from [RubyMotionSamples][]
  * [simple][]

[Hai]: https://github.com/rubymotion/teacup/tree/master/samples/ios/Hai
[AutoLayout]: https://github.com/rubymotion/teacup/tree/master/samples/ios/AutoLayout
[sweettea-example]: https://github.com/rubymotion/teacup/tree/master/samples/ios/sweettea-example

[Tweets]: https://github.com/rubymotion/teacup/tree/master/samples/osx/Tweets
[simple]: https://github.com/rubymotion/teacup/tree/master/samples/osx/simple

[RubyMotionSamples]: https://github.com/HipByte/RubyMotionSamples/tree/master/osx/Tweets

**Quick Install**

```bash
> gem install teacup
```
and in your Rakefile
```ruby
require 'teacup'
```

#### 10 second primer, iOS

1.  Create a `UIViewController` subclass:

    ```ruby
    class MyController < UIViewController
    ```
2.  Assign a stylesheet name:

    ```ruby
    class MyController < UIViewController
      stylesheet :main_screen
    ```
3.  Create a layout:

    ```ruby
    class MyController < UIViewController
      stylesheet :main_screen

      layout do
        subview(UIButton, :hi_button)
      end
    end
    ```
4.  Create the stylesheet (in `app/styles/` or somewhere near the controller)

    ```ruby
    Teacup::Stylesheet.new :main_screen do
      style :hi_button,
        origin: [10, 10],
        title: 'Hi!'
    end
    ```

#### 10 second primer, OS X

Pretty much the same!  Note that on OS X, view coordinates are based on having
the origin in the bottom-left corner, not the upper-left like it is *on every
other GUI system ever*. :-|

**You should use the `TeacupWindowController` parent class instead of `NSWindowController`**

1.  Create a `TeacupWindowController` subclass.

    ```ruby
    class MyController < TeacupWindowController
    ```
2.  Assign a stylesheet name:

    ```ruby
    class MyController < TeacupWindowController
      stylesheet :main_window
    ```
3.  Create a layout:

    ```ruby
    class MyController < TeacupWindowController
      stylesheet :main_window

      layout do
        subview(NSButton, :hi_button)
      end
    end
    ```
4.  Create the stylesheet (in `app/styles/` or somewhere near the controller)

    ```ruby
    Teacup::Stylesheet.new :main_window do
      style :hi_button,
        origin: [10, 10],
        title: 'Hi!'
    end
    ```

Teacup
------

Teacup's goal is to facilitate the creation and styling of your view hierarchy.
Say "Goodbye!" to Xcode & XIB files!

Teacup is composed of two systems:

- Layouts
  A DSL to create Views and to organize them in a hierarchy.  You assign the
  style name and style classes from these methods.

- Stylesheets
  Store the "styles" that get applied to your views.  The stylesheet DSL is
  meant to resemble CSS, but is targeted at iOS, and so the precedence rules are
  very different.

Teacup supports [Pixate][] and [NUI][], too, so you can use those systems for
styling and Teacup to manage your view hierarchy and apply auto-layout
constraints.  Teacup can also integrate with the [motion-layout][] gem!

### Table of Contents

* [Layouts](#layouts) — define your views
* [Stylesheets](#stylesheets) — style your views
  * [Using and re-using styles in a Stylesheet](#using-and-re-using-styles-in-a-stylesheet)
  * [Style via Stylename](#style-via-stylename)
  * [Extending Styles](#extending-styles)
  * [Style via View Class](#style-via-view-class)
  * [Importing stylesheets](#importing-stylesheets)
  * [Style via UIAppearance](#style-via-uiappearance) (iOS only)
* [UITableViews](#uitableviews) - This is important if you are using styles and
  constraints in a `UITableViewDelegate`.
* [More Teacup features](#more-teacup-features)
  * [Styling View Properties](#styling-view-properties)
  * [Orientation Styles](#orientation-styles) (iOS only)
  * [Animation additions](#animation-additions)
  * [Style Handlers](#style-handlers)
  * [Frame Calculations](#frame-calculations)
  * [Auto-Layout](#auto-layout)
  * [Motion-Layout](#motion-layout)
  * [Stylesheet extensions](#stylesheet-extensions)
    * [Autoresizing Masks](#autoresizing-masks)
    * [Device detection](#device-detection) (iOS only)
    * [Rotation helpers](#rotation-helpers) (iOS only)
* [Showdown](#showdown) — Cocoa vs Teacup
* [The Nitty Gritty](#the-nitty-gritty) — some implementation details and gotchas
* [Advanced Teacup Tricks](#advanced-teacup-tricks)
  * [Including `Teacup::Layout` on arbitrary classes](#including-teacup-layout-on-arbitrary-classes)
  * [Sweettea](#sweettea)
* [Misc notes](#misc-notes)
* [The Dummy](#the-dummy) — fixes “uncompiled selector” errors

Layouts
-------

The `Teacup::Layout` module is mixed into `UIViewController` and `UIView` on
iOS, and `NSWindowController`, `NSViewController`, and `NSView` on OS X. These
classes can take advantage of the view-hierarchy DSL.

You saw an example in the primer, using the
`UIViewController`/`NSWindowController` class method `layout`.  This is a helper
function that stores the layout code.  A more direct example might look like
this:

```ruby
# controller example
class MyController < UIViewController

  def viewDidLoad
    # we will modify the controller's `view`, assigning it the stylename `:root`
    layout(self.view, :root) do
      # these subviews will be added to `self.view`
      subview(UIToolbar, :toolbar)
      subview(UIButton, :hi_button)
    end
  end

end
```

You can use very similar code in your view subclasses.

```ruby
# view example
#
# if you use Teacup in all your projects, you can bundle your custom views with
# their own stylesheets
def MyView < UIView

  def initWithFrame(frame)
    super.tap do
      self.stylesheet = :my_stylesheet
      subview(UIImageView, :image)
    end
  end

end
```

The `layout` and `subview` methods are the work horses of the Teacup view DSL.

* `layout(view|ViewClass, stylename, style_classes, additional_styles, &block)`
  - `view|ViewClass` - You can layout an existing class or you can have Teacup
    create it for you (it just calls `new` on the class, nothing special).  This
    argument is required.
  - `stylename` (`Symbol`) - This is the name of a style in your stylesheet. It
    is optional
  - `style_classes` (`[Symbol,...]`) - Other stylenames, they have lower
    priority than the `stylename`.
  - `additional_styles` (`Hash`) - You can pass other styles in here as well,
    either to override or augment the settings from the `Stylesheet`.  It is
    common to use this feature to assign the `delegate` or `dataSource`.
  - `&block` - See discussion below
  - Returns the `view` that was created or passed to `layout`.
  - only the `view` arg is required.  You can pass any combination of
    stylename, style_classes, and additional_styles (some, none, or all).
* `subview(view|UIViewClass, stylename, style_classes, additional_styles, &block)`
  - Identical to `layout`, but adds the view to the current target

The reason it is so easy to define view hierarchies in Teacup is because the
`layout` and `subview` methods can be "nested" by passing a block.

```ruby
subview(UIView, :container) do  # create a UIView instance and give it the stylename :container
  subview(UIView, :inputs) do  # create another container
    @email_input = subview(UITextField, :email_input)
    @password_input = subview(UITextField, :password_input)
  end
  subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :submit_button)
end
```

These methods are defined in the `Layout` module. And guess what!?  It's easy
to add your *own view helpers*!  I refer to this as a "partials" system, but
really it's just Ruby code (and isn't that the best system?).

```ruby
# the methods you add here will be available in UIView/NSview,
# UIViewController/NSViewController/NSWindowController, and any of your own
# classes that `include Teacup::Layout`
module Teacup::Layout

  # creates a button and assigns a default stylename
  def button(*args, &block)
    # apply a default stylename
    args = [:button] if args.empty?

    # instantiate a button and give it a style class
    subview(UIButton.buttonWithType(UIButtonTypeCustom), *args, &block)
  end

  # creates a button with an icon image and label
  def button_with_icon(icon, title)
    label = UILabel.new
    label.text = title
    label.sizeToFit

    image_view = UIImageView.new
    image_view.image = icon
    image_view.sizeToFit

    button = UIButton.buttonWithType(UIButtonTypeCustom)
    button.addSubview(image_view)
    button.addSubview(label)

    # code could go here to position the icon and label, or at could be handled
    # by the stylesheet

    subview(button)
  end

end
```

###### example use of the helper methods

```ruby
class MyController < UIViewController

  layout do
    @button1 = button()
    @button2 = button(:blue_button)
    @button3 = button_with_icon(UIImage.imageNamed('email_icon'), 'Email')
  end

end
```

The `Controller##layout` method that has been used so far is going to be
the first or second thing you add to a controller when you are building an app
with Teacup.  It's method signature is

```ruby
# defined in teacup/teacup_controller.rb as Teacup::Controller module
UIViewController.layout(stylename=nil, styles={}, &block)
NSViewController.layout(stylename=nil, styles={}, &block)
NSWindowController.layout(stylename=nil, styles={}, &block)
```

* `stylename` is the stylename you want applied to your controller's `self.view`
  object.
* `styles` are *rarely* applied here, but one common use case is when you assign
  a custom view in `loadView`, and you want to apply settings to it.  I find it
  cleaner to move this code into the body of the `layout` block, though.
* `&block` is the most important - it is the layout code that will be called
  during `viewDidLoad`.

After the views have been added and styles have been applied Teacup calls the
`layoutDidLoad` method.  If you need to perform some additional initialization
on your views, you should do it in this method.  If you use the `layout` block
the styles have not yet been applied.  Frames will not be set, text and titles
will be empty, and images will not have images.  This all happens at the *end*
of the `layout` block.

Stylesheets
-----------

This is where you will store your styling-related code. Migrating code from your
controller or custom view into a stylesheet is very straightforward. The method
names map 1::1.

```ruby
# classic Cocoa/UIKit
def viewDidLoad
  self.view.backgroundColor = UIColor.grayColor
  #         ^.............^
end

# in Teacup
def viewDidLoad
  self.stylesheet = :main
  self.view.stylename = :root
end

Teacup::Stylesheet.new :main do
  style :root,
    backgroundColor: UIColor.grayColor
#   ^.............^
end
```

Nice! We turned three lines of code into nine!  Well, obviously the benefits
come in when we have *lots* of style code, and when you need to do app-wide
styling.

You can store stylesheets in any file.  It is common to use `app/styles.rb` or
`app/styles/main.rb`, if you have more than a few of 'em.  The
`Teacup::Stylesheet` constructor accepts a stylesheet name and a block, which
will contain your style declarations.

```ruby
Teacup::Stylesheet.new :main_menu do
  style :ready_to_play_button,
    backgroundColor: UIColor.blackColor,
    frame: [[20, 300], [50, 20]]
end

Teacup::Stylesheet[:main_menu]  # returns this stylesheet
```

Any method that accepts a single value can be assigned in a stylesheet.  Please
don't abuse this by hiding application logic in your stylesheets - these are
meant for *design*, not behavior.

### Using and re-using styles in a Stylesheet

- Styles are be applied via stylename (`style :label`) or class (`style UILabel`)
- Styles can extend other styles (`style :big_button, extends: :button`)
- A stylesheet can import other stylesheets (`import :app`)
- The special Appearance stylesheet can be used to apply styles to `UIAppearance`
  (`Teacup::Appearance.new`)

Let's look at each in turn.

### Style via Stylename

This is the most common way to apply a style.

```ruby
class MainController < UIViewController

  stylesheet :main  # <= assigns the stylesheet named :main to this controller

  layout do
    subview(UILabel, :h1)  # <= :h1 is the stylename
  end

end

Teacup::Stylesheet.new :main do  # <= stylesheet name

  style :h1,  # <= style name
    font: UIFont.systemFontOfSize(20)  # <= and this style is applied

end
```

When the stylesheet is applied (at the end of the `layout` block, when all the
views have been added), its `font` property will be assigned the value
`UIFont.systemFontOfSize(20)`.

But we didn't assign any text!

We can tackle this a couple ways.  You can apply "last-minute" styles in the
`layout` and `subview` methods:

```ruby
layout do
  subview(UILabel, :h1,
    # the `subview` and `layout` methods can apply styles
    text: "Omg, it's full of stars"
    )
end
```

In this case though we just have static text, so you can assign the text using
the stylesheet:

```ruby
Teacup::Stylesheet.new :main do

  style :h1,
    font: UIFont.systemFontOfSize(20)

  style :main_header,
    text: "Omg, it's full of stars",
    font: UIFont.systemFontOfSize(20)

end
```

### Extending Styles

Not very DRY though is it!?  We have to use a new style (`:main_header`) because
not all our labels say "OMG", but we want to use our font from the `:h1` style.
We can tell the `:main_header` style that it `extends` the `:h1` style:

```ruby
layout do
  subview(UILabel, :main_header)
end

Teacup::Stylesheet.new :main do

  style :h1,
    font: UIFont.systemFontOfSize(20)

  style :main_header, extends: :h1,
    text: "Omg, it's full of stars"

end
```

A common style when writing stylesheets is to use variables to store settings
you want to re-use.

```ruby
Teacup::Stylesheet.new :main do
  h1_font = UIFont.systemFontOfSize(20)

  style :h1,
    font: h1_font
  style :main_header, extends: :h1,
    text: "Omg, it's full of stars"
end
```

And you're not limited to one class that you can extend, it accepts an array

```ruby
Teacup::Stylesheet.new :main do
  h1_font = UIFont.systemFontOfSize(20)

  style :h1,
    font: h1_font

  style :label,
    textColor: UIColor.black

  style :main_header, extends: [:h1, :label],
    text: "Omg, it's full of stars"
end
```

### Style via View Class

If you need to apply styles to *all* instances of a `UIView`/`NSView` subclass,
you can do so by applying styles to a class name instead of a symbol.  This
feature is handy at times when you might otherwise use `UIAppearance` (which
teacup also supports!).

```ruby
Teacup::Stylesheet.new :app do

  style UILabel,
    font: UIFont.systemFontOfSize(20)

  style UITableView,
    backgroundColor: UIColor.blackColor

end
```

### Importing stylesheets

We've touched on the ability to write styles, extend styles, and apply styles to
a class.  Now we can introduce another feature that is even more useful for
applying styles to your entire app: import a stylesheet.

When you import a stylesheet, you receive all of its `style`s *and* you gain
access to its instance variables. This way you can define colors and margins and
such in a "parent" stylesheet.

```ruby
Teacup::Stylesheet.new :app do

  @header_color = UIColor.colorWithRed(7/255.0, green:16/255.0, blue:95/255.0, alpha: 1)
  @background_color = UIColor.colorWithRed(216/255.0, green:226/255.0, blue:189/255.0, alpha: 1)

  style :root,
    backgroundColor: @background_color

  style :header,
    textColor: @header_color

end

Teacup::Stylesheet.new :main do
  import :app

  style :subheader, extends: :header  # <= the :header style is imported from the :app stylesheet

  style :button,
    titleColor: @header_color  # <= @header_color is imported, too
end
```

### Style via UIAppearance

*iOS only*

And lastly, the `UIAppearance protocol` is supported by creating an instance of
`Teacup::Appearance`.  There is debatable benefit to using [UIAppearance][],
because it will apply styles to views that are outside your control, like the
camera/image pickers and email/message controllers.

But, it does come in handy sometimes... so here it is!

```ruby
Teacup::Appearance.new do

  # UINavigationBar.appearance.setBarTintColor(UIColor.blackColor)
  style UINavigationBar,
    barTintColor: UIColor.blackColor,
    titleTextAttributes: {
      UITextAttributeFont => UIFont.fontWithName('Trebuchet MS', size:24),
      UITextAttributeTextShadowColor => UIColor.colorWithWhite(0.0, alpha:0.4),
      UITextAttributeTextColor => UIColor.whiteColor
    }

  # UINavigationBar.appearanceWhenContainedIn(UINavigationBar, nil).setColor(UIColor.blackColor)
  style UIBarButtonItem, when_contained_in: UINavigationBar,
    tintColor: UIColor.blackColor

  # UINavigationBar.appearanceWhenContainedIn(UIToolbar, UIPopoverController, nil).setColor(UIColor.blackColor)
  style UIBarButtonItem, when_contained_in: [UIToolbar, UIPopoverController],
    tintColor: UIColor.blackColor

end
```

In your AppDelegate you need to call `Teacup::Appearance.apply`.  It will get
called automatically using the `UIApplicationDidFinishLaunchingNotification`,
but that notification is triggered *after* the method
`AppDelegate#didFinishLaunching(withOptions:)` is called.

###### app_delegate.rb
```ruby
class AppDelegate
  def didFinishLaunching(application, withOptions:options)
    Teacup::Appearance.apply

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    ctlr = MainController.new
    @window.rootViewController = UINavigationController.alloc.initWithRootController(ctlr)
    @window.makeKeyAndVisible

    true
  end

end
```

That block is called using the `UIApplicationDidFinishLaunchingNotification`,
but that notification is not called until the *end* of the
`application(application,didFinishLaunchingWithOptions:launchOptions)` method.
This is sometimes after your views have been created, and so they will not be
styled. If that is the case, call `Teacup::Appearance.apply` before creating
your `rootViewController`.

### Now go use Teacup!

You have enough information *right now* to go play with Teacup.  Check out the
example apps, write your own, whatever.  But read on to hear about why Teacup is
more than just writing `layouts` and applying styles.

Teacup as a utility
-------------------

When you are prototyping an app it is useful to bang out a bunch of code
quickly, and here are some ways that Teacup might help.

You can use all the methods above without having to rely on the entirety of
Teacup's layout and stylesheet systems. By that I mean *any* time you are
creating a view hierarchy don't be shy about using Teacup to do it.

`UIView` and `NSView` have the `style` method, which can be used to group a
bunch of customizations anywhere in your code. You don't *have* to pull out a
stylesheet to do it.

```ruby
# Custom Navigation Title created and styled by Teacup
self.navigationItem.titleView = layout(UILabel,
  text:'Title',
  font: UIFont.systemFontOfSize(12),
  )

# Customize contentView in a UITableViewCell dataSource method
def tableView(table_view, cellForRowAtIndexPath:index_path)
  cell_identifier = 'MyController - cell'
  cell = table_view.dequeueReusableCellWithIdentifier(cell_identifier)

  unless cell
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,
                        reuseIdentifier: cell_identifier)
    layout(cell.contentView) do
      subview(UIImageView, :image)
    end
  end

  return cell
end

# Use the `style` method on a view to apply your styling. This is a one-shot
# styling.
@label.style(textColor: UIColor.blueColor, text: 'Blue Label')
```

UITableViews
------------

Teacup is designed to be used in coordination with the controller life cycle,
but there are other life cycles that need to be considered as well.
UITableViews maintain a "queue" of cells that can be reused, and they need to be
restyled when the cell is created and re-used.

The solution is to apply the styles and layout constraints inside the
`tableView:willDisplayCell:forRowAtIndexPath:` delegate method.  In your
delegate, if you include the `Teacup::TableViewDelegate` module, you'll get this
behavior for free, and if you override this method, you can call `super` to have
the Teacup method run.

```ruby
class TableViewController < UITableViewController
  include Teacup::TableViewDelegate

  stylesheet :table

  def tableView(table_view, cellForRowAtIndexPath:index_path)
    cell = table_view.dequeueReusableCellWithIdentifier('cell id')

    layout(cell.contentView, :root) do
      cell.title_label = subview(UILabel, :title_label, :text => "title #{index_path.row}")
      cell.details_label = subview(UILabel, :details_label, :text => "details #{index_path.row}")
      cell.other_label = subview(UILabel, :other_label, :text => "other #{index_path.row}")
    end

    return cell
  end

  # This method is implemented by the Teacup::TableViewDelegate.  If you need
  # to implement it, be sure to call super.
  # def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
  #   super
  # end
end
```

Constraints and styles get applied before the view appears, even if the cell is
reused later.

More Teacup features
--------------------

There are a few (OK, a bunch) more features that Teacup provides that deserve
discussion:

- Styling View Properties
- Orientation Styles
- View Class Additions
- Style Handlers
- Frame Calculations
- Auto-Layout & [Motion-Layout][motion-layout]
- Stylesheet Extensions

### Styling View Properties

Styling a UIView is fun, but a UIView is often composed of many objects, like
the `layer`, or maybe an `imageView` or `textLabel` and so on.  You can style
those, too!

```ruby
# UITableViewCells have a contentView, a backgroundView, imageView, textLabel,
# detailTextLabel, and a layer! whew!
style :tablecell,
  layer: {  # style the layer!
    shadowRadius: 3
  },
  backgroundView: {  # style the background!
    backgroundColor: UIColor.blackColor
  },
  imageView: {  # style the imageView!
    contentMode: UIViewContentModeScaleAspectFill
  }
```

### Orientation Styles

*iOS only*

There's more to stylesheets than just translating `UIView` setters.  Teacup can
also apply orientation-specific styles.  These are applied when the view is
created (using the current device orientation) and when a rotation occurs.

```ruby
Teacup::Stylesheet.new :main do

  # this label hides when the orientation is landscape (left or right)
  style :label,
    landscape: {
      hidden: true
    },
    portrait: {
      hidden: false
    }

end
```

Combine these styles with [Frame Calculations][calculations] to have you view
frame recalculated automatically.

### Animation additions

We've already seen the Teacup related properties:

- `stylename`, the primary style name
- `style_classes`, secondary style names
- `style`, apply styles directly

Each of these has a corresponding method that you can use to facilitate
animations.

- `animate_to_stylename(stylename)`
- `animate_to_styles(style_classes)`
- `animate_to_style(properties)`

On OS X you have to use the `view.animator` property to perform animations.
This is supported, but it's kind of "hacky".

### Style Handlers

*This feature is used extensively by [sweettea][] to make a more intuitive
stylesheet DSL*

Teacup is, by itself, pretty useful, but it really does little more than map
Hash keys to `UIView` setters.  That's great, because it keeps the system easy
to understand.  But there are some methods in UIKit that take more than one
argument, or could benefit from some shorthands.

This is where Teacup's style handlers come in.  They are matched against a
`UIView` subclass and one or more stylenames, and they are used to apply that
style when you use it in your stylesheet.

```ruby
# this handler adds a `:title` handler to the UIButton class (and subclasses).
Teacup.handler UIButton, :title do |target, title|
  target.setTitle(title, forState: UIControlStateNormal)
end

# ...
subview(UIButton,
  title: 'This is the title'  # <= this will end up being passed to the handler above
  )

layout(UINavigationItem,
  title: 'This is the title'  # <= but this will not!  the handler above is restricted to UIButton subclasses
  )
```

[Other built-in handlers][other-handlers] are defined in `z_handlers.rb`.
Another useful one is the ability to make view the same size as its parent, and
located at the origin.

```ruby
style :container,
  frame: :full  # => [[0, 0], superview.frame.size]
```

[other-handlers]: https://github.com/rubymotion/teacup/tree/master/lib/teacup/z_core_extensions/z_handlers.rb

### Frame Calculations

*These are super cool, just don't forget your autoresizingMasks*

When positioning views you will often have situations where you want to have a
view centered, or 8 pixels to the right of center, or full width/height. All of
these relationships can be described using the `Teacup.calculate` method, which
is called automatically in any method that modifies the `frame` or `center`.

    frame, origin, size
    top/y, left/x, right, bottom, width, height
    center_x/middle_x, center_y/middle_y, center

```ruby
Teacup::Stylesheet.new :main do

  style :button,
    left: 8, top: 8,  # easy enough!
    width: '100% - 16',  # woah!  (O_o)
    height: 22

  style :top_half,
    frame: [[0, 0], ['100%', '50%']]
  style :bottom_half,
    frame: [[0, '50%'], ['100%', '50%']]

end
```

When this code executes, the string `'100% - 16'` is translated into the formula
`1.00 * target.superview.frame.size.width - 16`.  If the property is related to
the height or y-position, it will be calculated based on the height.

The frame calculations must be a string of the form `/[0-9]+% [+-] [0-9]+/`.  If
you need more "math-y-ness" than that, you can construct strings using interpolation.

```ruby
margin = 8

style :button,
  left: margin, top: margin,
  width: "100% - #{margin * 2}",
  height: 22

# just for fun, let's see what it would take to add a margin between these two views.
style :top_half,
  frame: [[0, 0], ['100%', "50% - #{margin / 2}"]]
style :bottom_half,
  frame: [[0, "50% + #{margin / 2}"], ['100%', "50% - #{margin / 2}"]]
```

One more example: The real power of the frame calculations comes when you
remember to set springs and struts. You can have a view "pinned" to the bottom
if you remember to set the `autoresizingMask`.

```ruby
Teacup::Stylesheet.new :main do

  style :button,
    # fixed width / height
    height: 22, width: 200,
    center_x: '50%',
    top: '100% - 30',  # includes an 8px margin from the bottom
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)
    # see the autoresizing extension below for an even better way to write this.
end
```

### Auto-Layout

*This is another much bigger topic than it is given space for here*

Teacup includes an Auto-Layout constraint DSL that you can use in your
stylesheets.  These methods are added to the `Stylesheet` class, so unless you
are in the context of a stylesheet, you will have to create your constraints in
longhand (you can still use the `Teacup::Constraint` class to help you!).

I won't sugar-coat it: Auto-Layout is hard.  Much harder than using frames and
springs and struts.  And honestly, I recommend you try using the
`Teacup.calculate` features mentioned above, they will take you far.

But at the end of the day, once you really understand the auto-layout system
that Apple released in iOS 6, you can build your UIs to be responsive to
different devices, orientations, and sizes. UIs built with auto-layout do not
usually need to adjust anything during a rotation.  The constraints take *care*
of it all.  It's impressive.

Here's a quick example that creates this shape.  The edges are bound to the
superview's frame.

    +-----+----------------+
    |     |                |
    |  A  |     B          |
    |     |          +-----| <\
    |     |          |  C  |  |_ 50% of B's height, minus 10 pixels
    +-----+----------+-----+ </
    ^--+--^          ^--+--^
       |_fixed (100)    |_fixed (100)

```ruby
Teacup::Stylesheet.new do
  style :A,
    constraints: [
      # these first three are all fixed, so super easy
      constrain_left(0),
      constrain_width(100),
      constrain_top(0),
      # here we go, here's a real constraint
      constrain(:bottom).equals(:superview, :bottom),
    ]

  style :B,
    constraints: [
      # B.left == A.right
      constrain(:left).equals(:A, :right),
      # B.height == A.height
      constrain(:height).equals(:A, :height),
      constrain(:right).equals(:superview, :right),
    ]

  style :C,  # <= this looks like a very grumpy style :C
    constraints: [
      constrain_width(100),
      # pin to bottom-right corner
      constrain(:right).equals(:superview, :right),
      constrain(:bottom).equals(:superview, :bottom),
      # 50% B.height - 10
      constrain(:height).equals(:B, :height).times(0.5).minus(10),
    ]

end
```

Writing views this way will either make your brain hurt, or make the math-nerd
in you chuckle with glee.  In this example you could go completely with just
frame calculation formulas and springs and struts.  Your frame code would still
be cluttered, just cluttered in a different way.

If you need to reset the list of constraints managed by Teacup, you can call
`reset_constraints` before you add the new styles to a UIView. This can be
useful when you need to define a new set of layout constraints for a dynamic
set of views.

This works on OS X and iOS, and you don't have to go changing the idea of "top"
and "bottom" even though OS X uses reversed frames.

### Motion-Layout

If you are using [Nick Quaranto][qrush]'s [motion-layout][] gem, you can use it
from within any class that includes `Teacup::Layout`.  Then benefit is that the
Teacup stylenames assigned to your views will be used in the dictionary that the
ASCII-based system relies on.

```ruby
layout do
  subview(UIView, :view_a)
  subview(UIView, :view_b)
  subview(UIView, :view_c)

  # if you need to apply these to a different view, or if you want to assign
  # different names to use in the ASCII strings
  # auto(layout_view=self.view, layout_subviews={}, &layout_block)

  auto do
    metrics 'margin' => 20
    vertical "|-[view_a]-margin-[view_b]-margin-[view_c]-|"
    horizontal "|-margin-[view_a]-margin-|"
    horizontal "|-margin-[view_b]-margin-|"
    horizontal "|-margin-[view_c]-margin-|"
  end
end

```

### Stylesheet extensions

Auto-Layout is just one Stylesheet extension, there are a few others.  And if
you want to write your own, just open up the `Teacup::Stylesheet` class and
start adding methods.

#### Autoresizing Masks

If you've used the SugarCube `uiautoresizingmask` methods, you'll recognize
these.  They are handy, and hopefully intuitive, shorthands for common springs
and struts.

In previous versions of Teacup these were available without needing the
`autoresize` prefix.  The old methods are still available, but deprecated.

```ruby
# keeps the width and height in proportion to the parent view
style :container,
  autoresizingMask: autoresize.flexible_width | autoresize.flexible_height

# the same, but using block syntax
style :container,
  autoresizingMask: autoresize { flexible_width | flexible_height }

# the same again, using a shorthand
style :container,
  autoresizingMask: autoresize.fill
```

The autoresize methods are grouped into four categories: `flexible, fill, fixed,
and float`. The flexible methods correspond 1::1 with the `UIViewAutoresizing*`
constants.

The `fill` methods (`fill,fill_top,fill_bottom,fill_left,fill_right`) will
stretch the width, or height, or both.  The location specifies where the view is
pinned, so `fill_top` will stretch the width and bottom margin, but keep it the
same distance from the top (not necessarily *at* the top, but a fixed distance).
`fill_right` will pin it to the right side, stretch the height, and have a
flexible left margin.

The `fixed` methods pin the view to one of nine locations:

    top_left    |  top_middle   |    top_right
    ------------+---------------+-------------
    middle_left |     middle    | middle_right
    ------------+---------------+-------------
    bottom_left | bottom_middle | bottom_right

    e.g. fixed_top_left, fixed_middle, fixed_bottom_right

The `float` methods fill in the last gap, when you don't want your view pinned
to any corner, and you don't want it to change size.

    # incidentally:
    float_horizontal | float_vertical == fixed_middle

#### Device detection

*iOS only*

Because the stylesheets are defined in a block, you can perform tests for device
and screen size before setting styles.  For instance, on an ipad you might want
to have a larger margin than on the iphone.

The `Stylesheet` device methods will help you create these conditions:

```ruby
Teacup::Stylesheet.new do
  if device_is? iPhone
    margin = 8
  elsif device_is? iPad
    margin = 20
  end

  style :container,
    frame: [[margin, margin], ["100% - #{margin * 2}", "100% * #{margin * 2}"]]
end
```

Multiple calls to `style` will *add* those styles, not replace.  So this code
works just fine:

```ruby
Teacup::Stylesheet.new do
  style :logo,
    origin: [0, 0]

  if device_is? iPhone
    style :logo, image: UIImage.imageNamed "small logo"
  elsif device_is? iPad
    style :logo, image: UIImage.imageNamed "big logo"
  end
end
```

#### Rotation helpers

*iOS only*

Because you can animate changes to the stylename or style_classes, you can make
it pretty easy to apply rotation effects to a `UIView` or `CALayer`.  The
`style_classes` property is especially useful for this purpose.

```ruby
style :container,
  frame: :full

# UIView transforms

style :rotated,
  transform: transform_view.rotate(pi / 2)  # pi and transform_view are methods on Stylesheet

style :not_rotated,
  transform: transform_view.rotate(0)

# CALayer transforms

style :rotated,
  layer: { transform: transform_layer.rotate(pi / 2) }

style :not_rotated,
  layer: { transform: transform_layer.rotate(0) }
```

These work even better when used with the [geomotion][] methods that extend
`CGAffineTransform` and `CATransform3D`.

```ruby
style :goofy,
  transform: CGAffineTransform.rotate(pi / 2).translate(100, 0).scale(2)
style :regular,
  transform: CGAffineTransform.identity

# CALayer uses CATransform3D objects
style :regular,
  layer: {
    transform: CATransform3D.rotate(pi / 2)
  }
```

### Showdown

As a recap, here is a translation of traditional Cocoa code done using Teacup.

No cool tricks here, just some plain ol' Cocoa.

```ruby
#
# Traditional Cocoa
#
class SomeController < UIViewController

  def viewDidLoad
    @field = UITextField.new
    @field.frame = [[10, 10], [200, 50]]
    @field.textColor = UIColor.redColor
    view.addSubview(@field)

    @search = UITextField.new
    @search.frame = [[10, 70], [200, 50]]
    @search.placeholder = 'Find something...'
    @search.textColor = UIColor.redColor
    view.addSubview(@search)
  end

  # perform the frame changes depending on orientation
  def willAnimateRotationToInterfaceOrientation(orientation, duration:duration)
    case orientation
    when UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight
      @field.frame = [[10, 10], [360, 50]]
      @search.frame = [[10, 70], [360, 50]]
    else
      @field.frame = [[10, 10], [200, 50]]
      @search.frame = [[10, 70], [200, 50]]
    end
  end

end

#
# Teacup
#

class SomeController < UIViewController

  stylesheet :some_view

  layout :root do
    subview(UITextField, :field)
    @search = subview(UITextField, :search)
  end

end

Teacup::Stylesheet.new(:some_view) do

  style :root,       # enable landscape rotation (otherwise only portrait is enabled)
    landscape: true  # this must be on the root-view, to indicate that this view is
                     # capable of handling rotations

  style :field,
    left:   10,
    top:    10,
    width:  200,
    height: 50,
    landscape: {
      width: 360  # make it wide in landscape view
    }

  style :search, extends: :field,
    left: 10,
    top: 70,
    placeholder: 'Find something...'

  style UITextField,                # Defining styles based on view class instead
    textColor: UIColor.redColor     # of style name.

end
```

The Nitty Gritty
----------------

#### Regarding Style Precedence

You need to be careful when extending styles and using orientation styles
because the precedence rules take some getting used to.  The goal is that you
can have all your style code in the stylesheets.  But you also need to be able
to animate your views, and rotating the device should not go reseting
everything.

So here's what happens.

When your controller is loaded, `viewDidLoad` is called, and that's where Teacup
creates the view hierarchy and applies the styles.  It is at the *end* of the
method that the styles are applied - not until all the views have been added.
The current device orientation will be used so that orientation-specific styles
will be applied.

Now Teacup goes quiet for a while.  Your app chugs along... until the user
rotates the device.

If you have orientation-specific styles, they will get applied. But the
*original* styles (the "generic" styles) **will not**.

However, there's a way around *that, too.*  If you call `restyle!` on a
`UIView`, that will reapply all the original stylesheet styles - orientation
*and* generic styles.

With me so far?  Orientation styles are reapplied whenever the device is
rotated. But generic styles are only applied in `viewDidLoad` and when
`restyle!` is called explicitly.

How does the `:extends` property affect things?

If your stylesheet defines orientation-specific styles and "generic" styles, the
orientation-specific styles win.  But if you *extend* a style that has
orientation-specific styles, your local generic styles will win.

The more "local" styles always win - and that applies to styles that you add
using the `subview/layout` methods, too. The only time it doesn't really apply
is if you apply styles using `UIView#style` or `UIView#apply_stylename`.  Those
are one-shot (they can get overwritten when `restyle!` is called).

There are also times when you either want (or must) override (or add to) the
stylesheet styles.  For instance, if you want to assign the `delegate` or
`dataSource` properties, this cannot be done from a `Stylesheet`.  But that's
okay, because we have a chance to add these styles in the `subview` and `layout`
methods.

```ruby
layout do
  subview(UITableView, delegate: self)
end
```

Styles applied here are one-shot.  It is the exact same as assigning the
`stylename` and `style_classes` and then calling `style`.  Because the
stylesheet is not necessarily applied immediately, these styles could be
overwritten before they take effect.

```ruby
layout do
  table_view = subview(UITableView, :tableview, delegate: self,
    font: UIFont.boldSystemFontOfSize(10)  # the stylesheet could override this during rotation
    )
end

def layoutDidLoad
  table_view.apply_stylename(:tableview_init)  # this will only get applied once
end
```

The idea here is that the closer the style setting is to where the view is
instantiated, the higher the precedence.

More examples!

```ruby
class MyController < UIViewController
  stylesheet :my_sheet
  layout do
    subview(UILabel, :label, text: 'overrides')
  end
end
Teacup::Stylesheet.new :my_sheet do
  style :generic_label,
    text: 'portrait',
    # these get applied initially, but after being rotated they will not get
    # applied again
    font: UIFont.boldSystemFontOfSize(10),
    textColor: UIColor.grayColor,
    landscape: {
      font: UIFont.boldSystemFontOfSize(12),
      textColor: UIColor.whiteColor,
    }  # this style should add a `portrait` setting that restores the font and color

  style :label, extends: :generic_label,
    font: UIFont.systemFontOfSize(10),  # this will override all the font settings
end
```

Advanced Teacup Tricks
----------------------

There are times when you might wish teacup "just worked", but please remember:
Teacup is not a "blessed" framework built by Apple engineers. We have access to
the same APIs that you do. That said, here are some use-cases where you can most
definitely *use* teacup, but you'll need to do a little more leg work.

### Trust your parent view - by using springs and struts

*...not autolayout*

It's been mentioned a few times in this document that Teacup will create & style
views in the `viewDidLoad` method.  That means that the `superview` property of
the controller's view will, necessarily, *not* be set yet.  `viewDidLoad` is
called after the view is instantiated (in `loadView`), and it hasn't been added
as a subview yet.

Auto-Layout is based on the relationship between two views - often a container
and child view.  It's an amazing system, but if that parent view *isn't
available*, well, you're not gonna have much success.

In the case of a UIViewController your "container" is the `self.view` property,
which by default has sensible springs setup so that it stretches to fill the
superview. It's not until you go messing with the `self.view` property, or are
not in the context of a `UIViewController` that things get hairy.

If this is the case, you should get some pretty obvious warning messages,
something along the lines of `Could not find :superview`.

### Including `Teacup::Layout` on arbitrary classes

I don't know about you, but I often write helper classes for tableviews that
appear on many screens in an app.  You should not shy away from adding teacup's
`Layout` module to these helper classes.

If you are using your controller as your table view dataSource, the `subview`
and `layout` methods continue to work as you expect them to.  This is for the
case when you are using a helper class.

```ruby
class TableHelper
  include Teacup::TableViewDelegate
  include Teacup::Layout

  stylesheet :table_helper

  def tableView(table_view, cellForRowAtIndexPath:index_path)
    cell_identifier = 'MyController - cell'
    cell = table_view.dequeueReusableCellWithIdentifier(cell_identifier)

    unless cell
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault
                          reuseIdentifier: cell_identifier)

      layout(cell.contentView) do
        subview(UIImageView, :image)
      end
      # cell.contentView and all child classes will "inherit" the :table_helper stylesheet
    end

    return cell
  end

end
```

### [Sweettea][]

*SugarCube + Teacup = Sweettea*

SugarCube was born of a desire to make Teacup stylesheets more readable, less
cluttered with Apple's verbose method names and constants.  Sweettea takes this
a step further, by implementing a wealth of Teacup handlers that translate
Symbols to constants and provide useful shorthands.

```ruby
style :button,
  normal: { image: 'button-white' },
  highlighted: { image: 'button-white-pressed' },
  title: 'Submit',
  shadow: {
    opacity: 0.5,
    radius: 3,
    offset: [3, 3],
    color: :black,
  },
  font: 'Comic Sans'

style :label,
  font: :bold,
  alignment: :center,
  color: :slateblue
```

Sweettea also offers some convenient styles that you can extend in your base
class.  You might want to either specify the Sweettea version you are using in
your Gemfile, or copy the stylesheet so that changes to Sweettea don't affect
your project.  Once that projet is at 1.0 you can rely on the styles not
changing.

```ruby
# buttons! :tan_button, :black_button, :green_button, :orange_button,
# :blue_button, :white_button, :gray_button
style :submit_button, extends: :white_button

# label sets more sensible defaults than a "raw" UILabel (like clear background)
style :header, extends: :label

# inputs!  these are not styled, they just setup keyboard and autocomplete
# settings
# :name_input, :ascii_input, :email_input, :url_input, :number_input,
# :phone_input, :secure_input
style :login_input, extends: :email_input
style :password_input, extends: :secure_input
```

Misc notes
----------

Multiple calls to `style` with the same stylename combines styles, it doesn't
replace the styles.

------

Styles are not necessarily applied immediately.  They are applied at the end of
the outermost `layout/subview` method, including the `UIViewController##layout`
block.  If you call `stylename=` or `stylesheet=` *outside* a `layout/subview`
block, your view will be restyled immediately.

------

Restyling a view calls `restyle!` on all child views, all the way down the tree.
Much care has been taken to call this method sparingly within Teacup.

------

Any styles that you apply in a `layout/subview` method are *not* retained, they
are applied immediately, and so the stylesheet can (and usually do) override
those styles if there is a conflict.  Only styles stored in a stylesheet are
reapplied (during rotation or in `restyle!`).

------

Stylesheets should not be modified once they are created - they cache styles by
name (per orientation).

------

You can add and remove a `style_class` using `add_style_class` and
`remove_style_class`, which will call `restyle!` for you if `style_classes`
array was changed.

------

If you need to do frame calculations outside of the stylesheet code, you should
do so in the `layoutDidLoad` method.  This is not necessary, though!  It is
usually cleaner to do the frame calculations in stylesheets, either using
[geomotion][], frame calculations, or auto-layout.

------

Within a `subview/layout` block views are added to the last object in
`Layout#superview_chain`.  Views are pushed and popped from this array in the
`Layout#layout` method, starting with the `top_level_view`.  If you include
`Teacup::Layout` on your own class, you do not *have* to implement
`top_level_view` unless you want to use the `subview` method to add classes to a
"default" target.

------

When `UIView` goes looking for its `stylesheet` it does so by going up the
responder chain.  That means that if you define the stylesheet on a parent view
or controller, all the child views will use that same stylesheet by default.  It
also means you can assign a stylesheet to a child view without worrying what the
parent view's stylesheet is.

Caveat!  If you implement a class that includes `Teacup::Layout`, you can assign
it a `stylesheet`. *That* stylesheet will be used by views created using
`layout` or `subview` even though your class is probably not part of the
responder chain.  Saying that `UIView` inherits its `stylesheet` from the
responder chain is not accurate; it actually uses `teacup_responder`, which
defaults to `nextResponder`, but it is assigned to whatever object calls the
`layout` method on the view.

------

If you use `Teacup::Appearance` but it is not styling the first screen of your
app (but, strangely, *does* style all other screens), try calling
`Teacup::Appearance.apply` before creating you create the `rootViewController`
(in your `AppDelegate`)..

------

The Dummy
---------

If you get an error that looks like this:

    Objective-C stub for message `setHidesWhenStopped:' type `v@:c' not
    precompiled. Make sure you properly link with the framework or library that
    defines this message.

You probably need to add your method to [dummy.rb][].  This is a compiler issue,
nothing we can do about it except build up a huge dummy.rb file that has just
about every method that you would want to style.  There is a [dummy.rb file for iOS][],
and [one for OS X][dummy.rb-osx].

If you need to add this method to your project, please give back to the
community by forking teacup and adding this method to the [dummy.rb][] file.
It's easy!  Create a subclass, define a method called `dummy`, and call the "not
precompiled" message inside it.  That will trigger the compiler to include this
method signature.

For instance, lets say you are styling a `UIPickerView` and you get the error:

    Objective-C stub for message `setShowsSelectionIndicator:' type ...

You would open up [dummy.rb][] and add the following code:

```ruby
class DummyPickerView < UIPickerView
private
  def dummy
    setShowsSelectionIndicator(nil)
  end
end
```

Recompile your project, and you should be good to go!

# Teacup is a Community Project!

Teacup was born out of the #rubymotion irc chatroom in the early days of
RubyMotion.  Its design, direction, and priorities are all up for discussion!

I'm [Colin T.A. Gray][colinta], the maintainer of the Teacup project.  I hope this
tool helps you build great apps!

[advanced]: https://github.com/rubymotion/teacup/#advanced-teacup-tricks
[calculations]: https://github.com/rubymotion/teacup/#frame-calculations
[dummy.rb]: https://github.com/rubymotion/teacup/tree/master/lib/teacup-ios/dummy.rb
[dummy.rb-osx]: https://github.com/rubymotion/teacup/tree/master/lib/teacup-ios/dummy.rb

[Pixate]: http://www.pixate.com
[NUI]: https://github.com/tombenner/nui
[geomotion]: https://github.com/clayallsopp/geomotion
[UIAppearance]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIAppearance_Protocol/Reference/Reference.html#//apple_ref/occ/intf/UIAppearance
[motion-layout]: https://github.com/qrush/motion-layout
[sweettea]: https://github.com/colinta/sweettea
[qrush]: https://github.com/qrush
[colinta]: https://github.com/colinta
