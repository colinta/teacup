 Teacup
========

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

Regular

```ruby
class SomeController < UIViewController
 def viewDidLoad
  @field = UITextField.new
  @field.height = 50
  @field.width  = 200
  view.addSubview(@field)
  
  @search = UITextField.new
  @search.height = 50
  @search.width  = 200
  @search.placeholder = 'Find something...'
  view.addSubview(@search)
  
  true
 end
end
```

Teacup

```ruby
# Stylesheet

Teacup::StyleSheet.new(:IPhone) do
 
 style :field,
  height: 50,
  width:  200
  
 style :search, like: :field,
  placeholder: 'Foo...'
 
end

# Controller

class SomeController < UIViewController
 
 def viewDidLoad
  view.addSubview(Teacup.style(:field, UITextField.new))
  view.addSubview(Teacup.style(:search))
  true
 end
 
end
```

 Development
-------------

*Current version*: v0.0.0 (or see `lib/teacup/version.rb`)

*Last milestone*: Pick a name

*Next milestone*: Pick a DSL

teacup, being a community project, moves in "spurts" of decision making and
coding.  Only the name — both the least and most important part :-) — is
decided.

We would love suggestions of any sort, and we're always free over at the `#teacuprb` channel on `irc.freenode.org`.


  Ideas that proposals should keep in mind
--------------------------------------------

1. output will conform, unless explicitly *disabled* to the [iOS HIG][]
2. should provide a few useful layouts (see [readme for layout proposals](teacup/tree/master/proposals/layout)):
     * basic: vertically arranged "things", or
     * form: label/input combinations arranged in a table
     * navbar: with ability to customize the buttons that get placed at the top
     * tabbar: similar, but with the tabs at the bottom instead of nav at the top
     * splitview: A splitview controller (for iPad Apps) with sane navigation defaults, nice loading webviews and JSON to populate the items in the popover menu

3. layouts should have ways of placing things relative to edges, so placing a
   label or nav at the "bottom" that spans the entire width should be *easy*.
   (This means we'll need to check for ipad or iphone.)
4. actions are either blocks, defined inline, or target/action combos (e.g.
   `target: self, action: :my_method`)
5. there should be a consistent "styling" language, preferably in a separate
   file, something that could be handed to a designer.  this is the BIG item!
6. teacup should take a little `config` block for easy configuration
7. Ideally, there should be some way to "inherit" styles in this language. So you can define a basic layout for all platforms and then tweak (see [readme for style proposals](teacup/tree/master/proposals/styles))

[iOS HIG]: http://developer.apple.com/library/ios/#DOCUMENTATION/UserExperience/Conceptual/MobileHIG/Introduction/Introduction.html

Bugs
----

Please, do *not* hesitate to report any bugs you find with our source at the [Issues](https://github.com/rubymotion/teacup/issues) page.

Actual proposals
------------------

1. [stylesheet][Commune], by [ConradIrwin][]
2. [teacup][teacup_colinta], by [colinta][]
3. [style][style_by_beakr], by [Beakr][]
3. [layout][layout_by_beakr], by [Beakr][]
4. [layout][layout_by_farcaller], by [farcaller][]
5. [hybrid][], by [colinta][]

[Commune]: https://github.com/colinta/teacup/blob/master/proposals/styles/stylesheet_by_conradirwin.rb
[teacup_colinta]: https://github.com/colinta/teacup/blob/master/proposals/styles/teacup_by_colinta.rb
[style_by_beakr]: https://github.com/colinta/teacup/blob/master/proposals/layout/beakr_improved.rb
[layout_by_beakr]: https://github.com/colinta/teacup/blob/master/proposals/styles/beakr_improved.rb
[layout_by_farcaller]: https://github.com/colinta/teacup/blob/master/proposals/styles/layout_by_farcaller.rb
[hybrid]: https://github.com/colinta/teacup/blob/master/proposals/layout/hybrid_style_and_layout_by_colinta.rb

[ConradIrwin]: https://github.com/ConradIrwin
[colinta]: https://github.com/colinta
[farcaller]: https://github.com/farcaller
[Beakr]: https://github.com/Beakr
