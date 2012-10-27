Teacup
======

A community-driven DSL for creating user interfaces on the iphone.

Using teacup, you can easily create and style layouts while keeping your code
dry.  The goal is to offer a rubyesque (well, actually a rubymotion-esque) way
to create interfaces programmatically.

**Check out a working sample app [here][Hai]!**

[Hai]: https://github.com/rubymotion/teacup/tree/master/samples/Hai

#### Installation

**Quick Install**

```bash
> gem install teacup
```

**Better Install**

However, it is recommended that you use [Bundler][] and [rvm][] to manage your
gems on a per-project basis, using a gemset.  See the
[Installation wiki page][Installation] for more help on doing that.

[Bundler]: http://gembundler.com/
[rvm]: https://rvm.io/
[Installation]: https://github.com/rubymotion/teacup/wiki/Installation

#### Showdown

Cocoa

```ruby
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

    true
  end

  # code to enable orientation changes
  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation == UIInterfaceOrientationPortraitUpsideDown
      return false
    end
    true
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
```

Teacup

```ruby
# Stylesheet

Teacup::Stylesheet.new(:some_view) do

  style :root,
    landscape: true  # enable landscape rotation (otherwise only portrait is enabled)
                     # this must be on the root-view, to indicate that this view is
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

# Controller

class SomeController < UIViewController

  # the stylesheet determines the placement and design of your views.  You can
  # also implement a stylesheet method, or assign the stylesheet name to the
  # UIViewController later.
  stylesheet :some_view

  # think of this as a nib file that you are declaring in your UIViewController.
  # it is styled according to the :root styles, and can add and style subviews
  layout :root do
    subview(UITextField, :field)
    @search = subview(UITextField, :search)
  end

  # you have to enable the auto-rotation stuff by implementing a
  # shouldAutorotateToInterfaceOrientation method
  def shouldAutorotateToInterfaceOrientation(orientation)
    # but don't worry, we made that painless, too!
    autorotateToOrientation(orientation)
  end

end
```

The orientation styling is really neat.  I think you'll find that you will be
more inspired to enable multiple orientations because the code is so much more
painless.

Stylesheets
-----------

The basic format for a `style` is a name and a dictionary of "styles".  These
are usually just methods that get called on the target (a `UIView` or `CALayer`,
most likely), but they can also perform introspection, using "handlers".

Basics
======

Create a stylesheet in any code file, usually `styles.rb` or `styles/main.rb`,
if you have a ton of 'em.  The `Teacup::Stylesheet` constructor accepts a
stylesheet name and a block, which will contain your style declarations.

```ruby
Teacup::Stylesheet.new :main_menu do
  style :ready_to_play_button,
    backgroundColor: UIColor.blackColor,
    frame: [[20, 300], [50, 20]]  # [[x, y], [w, h]]
end
```

Any method that accepts a single value can be assigned here.  Please don't abuse
this by hiding application logic in your stylesheets - these are meant for
*design*, not behavior.  That said, if you're coding by yourself - go for it! ;)

Stylesheets
===========

The `Teacup::Stylesheet` class has methods that create a micro-DSL in the
context of a `style` declaration.  You can view the source (most of them are
very short methods) in `lib/teacup/stylesheet_extensions/*.rb`.

```ruby
# autoresizingMask
style :spinner,
  center: [320, 460],
  autoresizingMask: flexible_left|flexible_right|flexible_top|flexible_bottom


# device-specific geometries - app_size, screen_size, and device/device? methods
style :root,
  origin: [0, 0],
  size: app_size  # doesn't include the status bar - screen_size does

if device? iPhone
  style :image, image: UIImage.imageNamed "my iphone image"
elsif device? iPad
  style :image, image: UIImage.imageNamed "my ipad image"
end

# the device method can be OR'd with the devices.  The return value is always a
# number, so make sure to compare to 0
if device|iPhone > 0
  # ...
end
# so yeah, you might as well use `device? iPhone`, in my opinion.


# rotations - use the identity and pi methods
style :button,
  layer: {
    transform: spin identity, 2*pi
  }
```

Orientations
============

Teacup stylesheets can be given orientation hashes.  The supported orientations
are:

- `portrait` - upright or upside down
- `upside_up`
- `upside_down`
- `landscape` - on either side
- `landscape_left` - "left" refers to the home button, e.g. the button is on the left.
- `landscape_right` - home button is on the right

An example should suffice:

```ruby
style :ready_to_play_button,
  portrait: {
    frame: [[20, 300], [50, 20]]
  },
  landscape: {
    frame: [[60, 300], [50, 20]]  # button moves over 40 pixels because of the wider screen
  }
```

That code is repetive, though, let's shorten it up by using precedence and some
aliases for setting the `frame`:

```ruby
style :ready_to_play_button,
  top: 300,
  width: 50,
  height: 20,
  portrait: {
    left: 20
  },
  landscape: {
    left: 60
  }
```

Styles declared in an orientation hash will override the "generic" styles
declared directly above it, so the above could also be written as:

```ruby
style :ready_to_play_button,
  top: 300,
  width: 50,
  height: 20,
  left: 20
  landscape: {
    left: 60  #  overrides left: 20
  }
```

Handlers
========

Above, we saw that we can assign `view.frame.x` by using the `left` property.
There *is* no `UIView#left` method, so this must be handled somewhere special...

Not **that** special, it turns out.  This used to be an internal translation,
but the list of "translations" was getting out of hand, and we realized that we
could break this out into a new feature.  **Handlers**.  Here is the `handler`
for the `left` property:

```ruby
Teacup.handler UIView, :left { |view, x|
  f = view.frame
  f.origin.x = x
  view.frame = f
}
```

How about setting the title of a `UIButton`?

```ruby
Teacup.handler UIButton, :title { |view, title|
  target.setTitle(title, forState: UIControlStateNormal)
}
```

You can also make aliases for long method names, or to shorten a style you use a
lot.  You can alias two ways - give multiple names in a `Teacup.handler` method,
or use `Teacup.alias`.

```ruby
# the actual `left` handler offers an alias `x`
Teacup, handler UIView, :left, :x { |view, x|
  f = view.frame
  f.origin.x = x
  view.frame = f
}

# but I speak japanese, and I want it to be called "hidari" instead, and I want
# top to be "ue".
Teacup.alias UIView, :hidari => :left, :ue => :top
```

extends:
=======

You might have a view where all the buttons or text fields have similar colors
or font.  You can have them extend a common style declaration.

```ruby
style :button,
  font: UIFont.systemFontOfSize(20)

style :ok_button, extends: :button,
  title: "OK"

style :cancel_button, extends: :button,
  title: "Cancel"
```

Precedence is important.  We said that "orientation" overrides "generic", but
that is only at the local `style` declaration level.  If you declare a property
in `style` that is set in an orientation hash in an extended style, *your*
property will win.

```ruby
style :button,
  portrait: {
    width: 40
  },
  landscape: {
    width: 45
  }

style :ok_button, extends: :button,
  title: "OK",
  width: 40  # width will always be 40, even in landscape

style :cancel_button, extends: :button,
  title: "Cancel"
  # width will be 40 or 45, depending on orientation
```

import
======

Each `UIView` or `UIViewController` can have only one stylesheet attached to it.
If you want to break up a stylesheet into multiple sheets, you will use `import`
to do it.

```ruby
Teacup::Stylesheet.new :base do
  style :button,
    font: UIFont.systemFontOfSize(20)
end

Teacup::Stylesheet.new :main do
  import :base

  style :ok_button, extends: :button,
    top: 10
end

Teacup::Stylesheet.new :register do
  import :base

  style :submit_button, extends: :button,
    top: 50
end
```

UIView classes
==============

You can style entire classes of `UIView`s!  These get merged in last (lowest
precedence), but they are a great way to get site-wide styles.  Put these in a
base stylesheet, and import that stylesheet everywhere.  The Apple
`UIAppearance` protocol/classes do this same thing, but in much more code ;-)

```ruby
Teacup::Stylesheet.new :base do
  style UIButton,
    font: UIFont.systemFontOfSize(20)
end

Teacup::Stylesheet.new :main do
  style :ok_button,  # no need to use extends
    top: 10
end

Teacup::Stylesheet.new :register do
  style :submit_button,  # no need to use extends
    top: 50
end
```

Precedence, and Style
==========

1. Within a `style` declaration, orientation-specific properties override generic properties
2. Imported properties will be merged in, but no values from (1) will be overridden
3. Extended styles will be merged in, but no values from (1) or (2) will be overridden
4. Styles applied to an ancestor will be merged in, but no values from (1) or (2) or (3) will be overridden

These rules are maintained in the `Style` class.  It starts by creating a Hash
based on the `style` declaration, then merges the orientation styles, if
applicable (orientation styles override).  Next it merges imports, then
extends, and finally the class ancestors.  At each "merge" except orientation
merges, it is a recursive-soft-merge, meaning that Hashes will be merged, but
existing keys will be left alone.

Unless you are going to be hacking on teacup, you do not need to understand the
nitty-gritty - just remember the precedence rules.

Development
-----------

*Current version*: v0.2.0 (or see `lib/teacup/version.rb`)

*Last milestone*: Release layout and stylesheet DSL to the world.

*Next milestone*: Provide default styles, that mimic Interface Builder's object library

**Changelog v0.2.0:**

- Stylesheets are no longer constants. Instead, they can be fetched by name: `Teacup::Stylesheet[:iphone]`
- Stylesheets can be assigned by calling the `stylesheet :stylesheet_name` inside a view controller.
- Ability to style based on view class.
- Support for orientation-based styles.


teacup, being a community project, moves in "spurts" of decision making and
coding.  We will announce when we are in "proposal mode".  That's a good time to
jump into the project and offer suggestions for its future.

And we're usually hanging out over at the `#teacuprb` channel on `irc.freenode.org`.

The Dummy
---------

If you get an error that looks like this:

    Objective-C stub for message `setHidesWhenStopped:' type `v@:c' not
    precompiled. Make sure you properly link with the framework or library that
    defines this message.

You need to add your method to dummy.rb.  This is a compiler issue, nothing we
can do about it except build up a huge dummy.rb file that has just about every
method that you would want to style.

Example
=======

The error above was from trying to style the
`UIActivityIndicatorView#hidesWhenStopped` property.  Make a new `Dummy` class,
subclass the class *where the method is defined* (not a subclass, please) and
add that method to a `dummy` method.  You should assign it `nil` so that the
method signature looks right.  And you should mark it private, too.

```ruby
class DummyActivityIndicatorView < UIActivityIndicatorView
private
  def dummy
    setHidesWhenStopped(nil)
  end
end
```

Bugs
----

Please report any bugs you find with our source at the
[Issues](https://github.com/rubymotion/teacup/issues) page.
