class HaiViewController < UIViewController

  def viewDidLoad
    view.addSubveiw(Teacup.style(:label, UILabel.new))
    true
  end

end
