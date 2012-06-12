
Teacup::Stylesheet.new(:iphone) do
  label_color = UIColor.blueColor

  style :hai,
    landscape: true

  style UILabel,
    textColor: label_color

  style :label,
    text: 'Hai!',
    backgroundColor: UIColor.whiteColor,
    top: 10,
    left: 100,
    width: 50,
    height: 20,
    layer: {
      transform: identity,
    },
    landscape_left: {
      layer: {
        transform: rotate(identity, pi/6, 0.3, 0.3, 0.3)
      },
      width: 75
    }

  style :footer,
    text: 'brought to you by teacup',
    backgroundColor: UIColor.lightGrayColor,
    top: 440,
    left: 120,
    width: 200,
    height: 20,
    landscape: {
      left: 280,
      top: 280
    }

end
