describe "Style Dependencies" do
  tests DependencyController

  it "should style size before styling center_x" do
    @controller.button.frame.origin.x.should == 35
    @controller.button.frame.origin.y.should == 0
    @controller.button.frame.size.width.should == 90
    @controller.button.frame.size.height.should == 90
  end

end
