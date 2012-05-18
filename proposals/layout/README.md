## A note on the layouts

While creating "generic" views (e.g. a form) in a simple way is a nice idea for ruby to iOS newcomers, we need to think of the possibility to easily express the layout of a view in code (much like NSLayoutConstraint does that for Cocoa). iOS views tend to be simpler in terms of resizing (that is you have a pretty common pre-defined set of possible sizes), so we don't need the system as flexible as Cocoa Auto Layout is.

### A note on how this is expected to be different from styles

The layout idea is to place different views in relation to parent view and each other, and, possibly provide subview identification (naming). So, the properties that layout manager is working with are frame and bounds.

On the other side, all other visual appearance properties belong to a style (much like UIAppearance).