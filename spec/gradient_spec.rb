describe "Gradient" do
  tests GradientController

  before do
    @root_view = window.subviews[0]
  end

  it "should insert gradient layer when gradient style is set" do
    @root_view.style(gradient: { colors: [UIColor.redColor, UIColor.yellowColor] })
    @root_view.layer.sublayers.size.should == 1
    @root_view.layer.sublayers.first.class.should == CAGradientLayer
  end

  it "should not insert another gradient layer when gradient style is changed" do
    @root_view.style(gradient: { colors: [UIColor.redColor, UIColor.yellowColor] })
    @root_view.style(gradient: { colors: [UIColor.greenColor, UIColor.whiteColor] })
    @root_view.layer.sublayers.size.should == 1
  end

  it "should change gradient layer when gradient style is changed" do
    @root_view.style(gradient: { colors: [UIColor.redColor, UIColor.yellowColor] })
    before = @root_view.layer.sublayers.first.colors.first
    @root_view.style(gradient: { colors: [UIColor.greenColor, UIColor.whiteColor] })
    after = @root_view.layer.sublayers.first.colors.first
    before.should != after
  end

  it "should accept CGColors" do
    @root_view.style(gradient: { colors: [UIColor.redColor.CGColor, UIColor.yellowColor.CGColor] })
    @root_view.layer.sublayers.size.should == 1
  end
end
