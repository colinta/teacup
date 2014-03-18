Teacup::Stylesheet.new :base do
  back_color = UIColor.grayColor
  dark_color = UIColor.blackColor
  mid_color = UIColor.redColor

  style UIView,
    backgroundColor: back_color,
    nav_btn_tint: mid_color

  style :custom_label,
    text: 'App Stuff!',
    backgroundColor: UIColor.clearColor,
    numberOfLines: 0,
    font: UIFont.boldSystemFontOfSize(40),
    textColor: UIColor.whiteColor,
    shadowColor: UIColor.blackColor,
    textAlignment: UITextAlignmentCenter,
    layer: {
      transform: transform_layer.identity,
      shadowRadius: 20,
      shadowOpacity: 0.5,
      masksToBounds: false
    }

  style :custom_button,
    width: 142,
    height: 34,
    title: "Button"

  style :custom_switch,
    on: true

end
