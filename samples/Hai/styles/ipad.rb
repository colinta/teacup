Teacup::Stylesheet.new(:IPad) do

  style UILabel,
    textColor: UIColor.blueColor

  style :label,
    text: 'Hai!',
    backgroundColor: UIColor.whiteColor,
    top: 10,
    left: 100,
    width: 200,
    height: 50

  style :footer,
    text: 'brought to you by teacup',
    backgroundColor: UIColor.lightGrayColor,
    top: 310,
    left: 100,
    width: 200,
    height: 50

end
