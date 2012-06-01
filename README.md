Teacup
======

A community-driven DSL for creating user interfaces on the iphone.

By including the `Teacup` module, you can easily create layouts that adhere to
the [iOS user interface guidelines][iOS HIG], and it's an easy way to assign labels,
delegators, and datasources.

The goal is not to simply rename CocoaTouch method names, but to offer a
rubyesque (well, actually a rubymotion-esque) way to create an interface.

Using stylesheets and layouts, it makes coding an iOS app like designing a website with HTML and CSS.

**Check out a working sample app [here](https://github.com/rubymotion/teacup/tree/master/samples/Hai)!**

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

  # require all the directories in order.
  app.files = dirs.map{|d| Dir.glob(File.join(app.project_dir, "#{d}/**/*.rb")) }.flatten
```


#### Showdown

Cocoa

```ruby
class SomeController < UIViewController
 def viewDidLoad

  field = UITextField.new
  field.frame = [10, 10, 50, 200]
  view.addSubview(field)

  search = UITextField.new
  field.frame = [10, 70, 50, 200]
  search.placeholder = 'Find something...'
  view.addSubview(search)

  true
 end
end
```

Teacup

```ruby
# Stylesheet

Teacup::Stylesheet.new(:iphone) do

  style :field,
    left: 10,
    top: 10,
    height: 50,
    width:  200

  style :search, extends: :field,
    left: 10,
    top: 70,
    placeholder: 'Find something...'

end

# Controller

class SomeController < UIViewController

  # don't think of this as "viewDidLoad", think of it as a nib file, that you
  # are declaring in your UIViewController.
  layout do
    subview(UITextField, :field)
    subview(UITextField, :search)
  end

end
```

Development
-----------

*Current version*: v0.0.1 (or see `lib/teacup/version.rb`)

*Last milestone*: Pick a DSL

*Next milestone*: Release layout and stylesheet DSL to the world.

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
