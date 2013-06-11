describe "Stylesheet - Device" do

  it "should have device methods" do
    stylesheet = Teacup::Stylesheet.new
    stylesheet.iPhone.should.not == nil
    stylesheet.iPhoneRetina.should.not == nil
    stylesheet.iPhone4.should.not == nil
    stylesheet.iPhone35.should.not == nil
    stylesheet.iPad.should.not == nil
    stylesheet.iPadRetina.should.not == nil
  end

  it "should return appropriate sizes" do
    stylesheet = Teacup::Stylesheet.new

    device = UIDevice.currentDevice.userInterfaceIdiom
    case device
    when UIUserInterfaceIdiomPhone
      if UIScreen.mainScreen.respond_to?(:scale) && UIScreen.mainScreen.scale == 2
        stylesheet.device_is?(:iPhoneRetina).should == true
      else
        stylesheet.device_is?(:iPhoneRetina).should == false
      end

      if UIScreen.mainScreen.bounds.size.height == 568
        stylesheet.screen_size.height.should == 568
        stylesheet.device_is?(:iPhone4).should == true
      else
        stylesheet.screen_size.height.should == 480
        stylesheet.device_is?(:iPhone35).should == true
      end
      stylesheet.screen_size.width.should == 320
      stylesheet.device_is?(:iPhone).should == true
    when UIUserInterfaceIdiomPad
      if UIScreen.mainScreen.respond_to?(:scale) && UIScreen.mainScreen.scale == 2
        stylesheet.device_is?(:iPadRetina).should == true
      else
        stylesheet.device_is?(:iPadRetina).should == false
      end
      stylesheet.screen_size.width.should == 768
      stylesheet.screen_size.height.should == 1024
      stylesheet.device_is?(:iPad).should == true
    end
  end

end
