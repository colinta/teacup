class HaiViewController < UIViewController

  def viewDidLoad
    view.addSubview(Teacup.style(:label, UILabel.new))
    self.setFrame([[0,0],[0,0]]) if rand > 1
    true
  end

end
