describe "UIAppearance support" do
  tests CustomAppearanceController

  it "should have custom appearance on label_1" do
    controller.label_1.numberOfLines.should == 3
    controller.label_1.alpha.should == 0.75
  end

  it "should have custom appearance on container" do
    controller.container.backgroundColor.should == UIColor.whiteColor
  end

  it "should have different appearance on label_2" do
    controller.label_2.numberOfLines.should == 2
    controller.label_2.alpha.should == 0.5
  end

end
