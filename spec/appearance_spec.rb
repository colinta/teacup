describe "UIAppearance support" do
  tests CustomAppearanceController

  it "should have custom appearance on label_1" do
    font = UIFont.systemFontOfSize(14)
    controller.label_1.numberOfLines.should == 1
  end

  it "should have custom appearance on container" do
    controller.container.backgroundColor.should == UIColor.whiteColor
  end

  it "should have different appearance on label_2" do
    font = UIFont.boldSystemFontOfSize(20)
    controller.label_2.numberOfLines.should == 2
  end

end
