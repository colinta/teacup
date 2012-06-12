Teacup
======

A community-driven DSL for creating user interfaces on the iphone.

Using teacup, you can easily create and style layouts while keeping your code
dry.  The goal is to offer a rubyesque (well, actually a rubymotion-esque) way
to create interfaces programmatically.

**Check out a working sample app [here][Hai]!**

[Hai]: https://github.com/rubymotion/teacup/tree/master/samples/Hai

#### Installation

First get the teacup library into your local project using git submodules:

```bash
$ git submodule add https://github.com:rubymotion/teacup vendor/teacup
```

Then add the teacup library to your Rakefile:

```
  # Add libraries *before* your app so that you can access constants they define safely
  #
  dirs = ['vendor/teacup/lib', 'app']

  Motion::Project::App.setup do |app|
    # ...
    app.files = dirs.map{|d| Dir.glob(File.join(app.project_dir, "#{d}/**/*.rb")) }.flatten
  end
```

You can run the test suite or compile the test app:

```bash
$ cd vendor/teacup
$ rake spec  # or just rake, to run the app.
```

#### Showdown

Cocoa

```ruby
class SomeController < UIViewController

  def viewDidLoad

    @field = UITextField.new
    @field.frame = [[10, 10], [200, 50]]
    view.addSubview(@field)

    @search = UITextField.new
    @search.frame = [[10, 70], [200, 50]]
    @search.placeholder = 'Find something...'
    view.addSubview(@search)

    true
  end

  # code to handle orientation changes
  def shouldAutorotateToInterfaceOrientation(orientation)
    if orientation == UIDeviceOrientationPortraitUpsideDown
      return false
    end
    true
  end

  # perform the frame changes
  def willAnimateRotationToInterfaceOrientation(orientation, duration:duration)
    case orientation
    when UIDeviceOrientationLandscapeLeft, UIDeviceOrientationLandscapeRight
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

The orientation styling is really neat, I think you'll find that you will be
more encouraged to enable multiple orientations, since the code is pretty
painless.



Development
-----------

*Current version*: v0.2.0 (or see `lib/teacup/version.rb`)

*Last milestone*: Release layout and stylesheet DSL to the world.

*Next milestone*: Provide default styles, that mimic Interface Builder's object library

teacup, being a community project, moves in "spurts" of decision making and
coding.

We would love suggestions of any sort, and we're always free over at the
`#teacuprb` channel on `irc.freenode.org`.

Bugs
----

Please, do *not* hesitate to report any bugs you find with our source at the
[Issues](https://github.com/rubymotion/teacup/issues) page.

Use cases
---------

Problems to solve... these would make for good example code.

1. TableViewCell:

        **************************************
        * |======| Title Goes here, bold     *
        * | icon |                           *
        * |======| mm/dd/YYYY     more info  *  <= smaller, gray captions
        **************************************

2. iPhone address book entry:

        ************************
        * <back=  Joey  [save] * <= navigation controller
        *----------------------*
        * |==|  [ Joey       ] *
        * |:)|  [ Joe        ] * <= icon, and names in text fields
        * |==|  [ McBobby    ] *
        *                      *
        * Address [ 123 St.  ] * <= labels and text fields
        * Phone   [ 123-4567 ] *
        *                      *
        * Notes                *
        * /------------------\ *
        * | What a great     | *
        * | guy!             | *
        * \------------------/ *
        *                      *
        * ( + add field      ) *
        * ( ! delete !       ) * <= red!
        ************************

3. iPad drawing program layout!

                  V split view
        ************************************
        * Drawings |  [+]  [x]  [>]        * <= toolbar, add, trash, send/forward
        *==========|-----------------------*
        * Square > |                       *
        * Box    > |                       *
        *.Circle.>.|     O                 *
        *          |                       *
        *          |-----------------------*
        *          | [/] [#] [O] [T]       * <= toolbar, black. pen, box, circle, text
        ************************************

Good luck!
