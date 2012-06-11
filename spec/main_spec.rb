describe "Application 'Scorrerest'" do
  before do
    UIDevice.currentDevice.beginGeneratingDeviceOrientationNotifications
    @app = UIApplication.sharedApplication
    @view_ctrlr = @app.windows[0].rootViewController
  end

  after do
    UIDevice.currentDevice.endGeneratingDeviceOrientationNotifications
  end

  it "has one window" do
    @app.windows.size.should == 1
  end

  it "should have a root view" do
    view_ctrlr_view = @view_ctrlr.view
    view_ctrlr_view.subviews.length.should == 1
    view_ctrlr_view.subviews[0].class.should == UIView
  end

  describe "view controller" do

    it "should be able to rotate" do
      @view_ctrlr.shouldAutorotateToInterfaceOrientation(UIDeviceOrientationPortrait).should == true
      @view_ctrlr.shouldAutorotateToInterfaceOrientation(UIDeviceOrientationLandscapeLeft).should == true
      @view_ctrlr.shouldAutorotateToInterfaceOrientation(UIDeviceOrientationLandscapeRight).should == true
      @view_ctrlr.shouldAutorotateToInterfaceOrientation(UIDeviceOrientationPortraitUpsideDown).should == false
    end
  end

  describe "root view" do

    before do
      @root_view = @app.windows[0].subviews[0]
    end

    it "root view should be styled as 'root'" do
      @root_view.stylename.should == :root
      @root_view.frame.origin.x.should == 0
      @root_view.frame.origin.y.should == 0
      @root_view.frame.size.width.should == 320
      @root_view.frame.size.height.should == 480
      @root_view.backgroundColor.should == UIColor.yellowColor
    end

  end

  describe "background view" do

    before do
      @background = @app.windows[0].subviews[0].subviews[0]
    end

    it "should be styled as :background" do
      @background.stylename.should == :background
      @background.frame.origin.x.should == 10
      @background.frame.origin.y.should == 30
      @background.frame.size.width.should == 300
      @background.frame.size.height.should == 440
      @background.backgroundColor.should == UIColor.darkGrayColor
    end

    it "background view should have subviews" do
      @background.subviews.length.should == 3
      @background.subviews[0].class.should == UILabel
      @background.subviews[1].class.should == UILabel
      @background.subviews[2].class.ancestors.include?(UIButton).should == true
    end

    describe "background subviews" do

      before do
        @welcome = @background.subviews[0]
        @footer = @background.subviews[1]
        @button = @background.subviews[2]
      end

      it "should have all UILabels with color blue" do
        @welcome.textColor.should == UIColor.blueColor
        @footer.textColor.should == UIColor.blueColor
      end

      describe "welcome" do
        it "should be styled as :welcome" do
          @welcome.stylename.should == :welcome
          @welcome.frame.origin.x.should == 10
          @welcome.frame.origin.y.should == 40
          @welcome.frame.size.width.should == 280
          @welcome.frame.size.height.should == 20
          @welcome.text.should == "Welcome to teacup"
        end
      end

      describe "footer" do
        it "should be styled as :footer" do
          @footer.stylename.should == :footer
          @footer.frame.origin.x.should == 10
          @footer.frame.origin.y.should == 410
          @footer.frame.size.width.should == 280
          @footer.frame.size.height.should == 20
          @footer.text.should == "This is a teacup example"
        end
      end

      describe "button" do
        it "should be styled as :next_message" do
          @button.stylename.should == :next_message
          @button.frame.origin.x.should == 150
          @button.frame.origin.y.should == 370
          @button.frame.size.width.should == 130
          @button.frame.size.height.should == 20
          @button.titleForState(UIControlStateNormal).should == "Next Message..."
        end
      end

    end

  end

  describe "background view in landscape" do

    before do
      @background = @app.windows[0].subviews[0].subviews[0]
      @view_ctrlr.landscape_only
      UIApplication.sharedApplication.setStatusBarOrientation(UIDeviceOrientationLandscapeLeft, animated:false)
    end

    it "should be in landscape" do
      # the rest of these tests *pass*, but the device orientation isn't actually
      # updated to be landscape yet... :-/
      UIDevice.currentDevice.orientation.should > 0
    end

    it "should be styled as :background - landscape" do
      @background.stylename.should == :background
      @background.frame.origin.x.should == 10
      @background.frame.origin.y.should == 30
      @background.frame.size.width.should == 460
      @background.frame.size.height.should == 280
      @background.backgroundColor.should == UIColor.lightGrayColor
    end

    describe "background subviews in landscape" do

      before do
        @welcome = @background.subviews[0]
        @footer = @background.subviews[1]
        @button = @background.subviews[2]
      end

      describe "welcome" do
        it "should be styled as :welcome - landscape" do
          @welcome.stylename.should == :welcome
          @welcome.frame.origin.x.should == 90
          @welcome.frame.origin.y.should == 40
          @welcome.frame.size.width.should == 280
          @welcome.frame.size.height.should == 20
          @welcome.text.should == "Welcome to teacup"
        end
      end

      describe "footer" do
        it "should be styled as :footer - landscape" do
          @footer.stylename.should == :footer
          @footer.frame.origin.x.should == 90
          @footer.frame.origin.y.should == 250
          @footer.frame.size.width.should == 280
          @footer.frame.size.height.should == 20
          @footer.text.should == "This is a teacup example"
        end
      end

      describe "button" do
        it "should be styled as :next_message - landscape" do
          @button.stylename.should == :next_message
          @button.frame.origin.x.should == 20
          @button.frame.origin.y.should == 200
          @button.frame.size.width.should == 130
          @button.frame.size.height.should == 20
          @button.titleForState(UIControlStateNormal).should == "Next Message..."
        end
      end

    end

  end

end

describe "Stylesheet 'first'" do
  before do
    @stylesheet = Teacup::Stylesheet[:first]
  end

  it "should exist" do
    @stylesheet.nil?.should == false
  end

  it "should define some styles" do
    @stylesheet.query(:footer)[:text].nil?.should == false
    @stylesheet.query(:footer)[:text].should == "This is a teacup example"
  end

  it "should union the next_message styles" do
    @stylesheet.query(:next_message)[:title].should == "Next Message..."
    @stylesheet.query(:next_message)[:portrait].empty?.should == false
  end

end
