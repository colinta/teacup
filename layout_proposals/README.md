## A note on the layouts

While creating "generic" views (e.g. a form) in a simple way is a nice idea for ruby to iOS newcomers, we need to think of the possibility to easily express the layout of a view in code (much like NSLayoutConstraint does that for Cocoa). iOS views tend to be simpler in terms of resizing (that is you have a pretty common pre-defined set of possible sizes), so we don't need the system as flexible as Cocoa Auto Layout is.
