class HaiViewController < UIViewController

  layout :hai do
    subview(UILabel, :label)
    subview(UILabel, :footer)
  end

  def stylesheet
    Teacup::Stylesheet::IPad
  end

end
