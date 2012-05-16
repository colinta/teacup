 Teacup
========

A community-driven DSL for creating user interfaces on the iphone.

By including the `Teacup` module, you can easily create layouts that adhere to
the [iOS user interface guidelines][iOS HIG], and it's an easy way to assign labels,
delegators, and datasources.

The goal is not to simply rename CocoaTouch method names, but to offer a
rubyesque (well, actually a rubymotion-esque) way to create an interface.

Using stylesheets and layouts, it makes coding an iOS app like designing a website with HTML and CSS.

 Development
-------------

*Current version*: v0.0.0 (or see `lib/teacup/version.rb`)

*Last milestone*: Pick a name

*Next milestone*: Pick a DSL

teacup, being a community project, moves in "spurts" of decision making and
coding.  Only the name — both the least and most important part :-) — is
decided.

We are currently open to ideas for the DSL syntax.  Please fork, add a proposal,
and we will pick one in the #rubymotion channel on irc.freenode.net.

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

Actual proposals
------------------

1. [stylesheet][Commune], by [ConradIrwin][]
2. [teacup][teacup], by [colinta][]

[iOS HIG]: http://developer.apple.com/library/ios/#DOCUMENTATION/UserExperience/Conceptual/MobileHIG/Introduction/Introduction.html
[Commune]: https://github.com/colinta/teacup/blob/master/proposals/stylesheet_by_conradirwin.rb
[teacup]: https://github.com/colinta/teacup/blob/master/proposals/teacup_by_colinta.rb
[ConradIrwin]: https://github.com/ConradIrwin
[colinta]: https://github.com/colinta
