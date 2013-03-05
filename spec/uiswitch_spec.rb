describe "UISwitch test" do
  describe "it should style `on`" do
    before do
      @ctlr = UIViewController.new
    end

    it "should be on" do
      switch = @ctlr.subview(UISwitch, on: true)
      switch.on?.should == true
    end
    it "should be off" do
      switch = @ctlr.subview(UISwitch, on: false)
      switch.on?.should == false
    end
  end
end
