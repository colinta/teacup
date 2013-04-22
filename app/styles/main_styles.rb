
Teacup::Stylesheet.new(:main) do

  # enable orientations on the root view
  style :root,
    left: 0,
    top: 0,
    width: 320,
    height: 480,
    backgroundColor:  UIColor.yellowColor,
    portrait:    true,
    upside_down:  false,

    layer: {
      cornerRadius: 10.0,
    },

    landscape: {
      backgroundColor: UIColor.redColor,
    },

    landscape_left: {
      layer: {
        transform: spin(identity, -pi / 2),
      },
    },

    landscape_right: {
      layer: {
        transform: spin(identity, pi / 2),
      },
    }

  style(UILabel, {
    textColor:  UIColor.blueColor,
  })

  style CustomView,
    # for testing how styles override (this gets overridden by any property in
    # a style block, regardless of whether it is in an orientation style)
    portrait: {
      alpha: 0.75
    },
    landscape: {
      alpha: 0.75
    }

  style(:background, {
    alpha: 0.5,
    left: 10,
    top: 30,
    backgroundColor:  UIColor.blackColor,

    portrait: {
      width:  300,
      height: 440,
      backgroundColor:  UIColor.darkGrayColor,
    },

    landscape: {
      width:  460,
      height: 280,
      alpha: 0.8,
      backgroundColor:  UIColor.lightGrayColor,
    },
  })

  style(:welcome, {
    left:   10,
    top:    40,
    width:  280,
    height: 20,
    text:   "Welcome to teacup",
    landscape: {
      left: 90,
    },
  })

  style(:footer, {
    left:   10,
    top:    410,
    width:  280,
    height: 20,
    text:   "This is a teacup example",
    landscape: {
      top:  250,
      left: 90,
    },
  })


  style :next_message,
    width:   130,
    height:  20,
    portrait: nil,
    title:   "Next Message..."

  # deliberately declaring this twice for testing purposes
  # (declaring twice extends it)
  style :next_message,
    portrait: {
      left:   150,
      top:    370,
    },

    landscape: {
      left:   20,
      top:    200,
    }

end
