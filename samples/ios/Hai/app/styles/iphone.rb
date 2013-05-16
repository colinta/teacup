
Teacup::Stylesheet.new(:iphone) do
  label_color = UIColor.blueColor

  style :hai,
    landscape: true

  style UILabel,
    textColor: label_color

  style :label,
    text: 'Hai!',
    backgroundColor: UIColor.whiteColor,
    portrait: {
      layer: {
        transform: transform_layer.identity,
      },
      top: 10,
      left: 100,
      height: 20,
      width: 50
    },
    landscape_left: {
      layer: {
        transform: transform_layer.rotate(pi/6, 0.3, 0.3, 0.3)
      },
      top: 40,
      left: 100,
      height: 20,
      width: 75
    }

  style :footer,
    text: 'brought to you by teacup',
    backgroundColor: UIColor.lightGrayColor,
    width: 200,
    height: 20,
    portrait: {
      top: 440,
      left: 120,
    },
    landscape: {
      top: 280,
      left: 280,
    }

end
