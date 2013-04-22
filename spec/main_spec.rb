describe "Application 'Teacup'" do
  tests MainController

  before do
    @root_view = window.subviews[0]
    @background = @root_view.subviews[0]
    @welcome = @background.subviews[0]
    @footer = @background.subviews[1]
    @button = @background.subviews[2]
  end

  it "should have a root view" do
    view_ctrlr_view = controller.view
    view_ctrlr_view.subviews.length.should == 1
    view_ctrlr_view.subviews[0].class.should == CustomView
  end

  it "should be able to rotate" do
    controller.shouldAutorotateToInterfaceOrientation(UIInterfaceOrientationPortrait).should == true
    controller.shouldAutorotateToInterfaceOrientation(UIInterfaceOrientationLandscapeRight).should == true
    controller.shouldAutorotateToInterfaceOrientation(UIInterfaceOrientationLandscapeLeft).should == true
    controller.shouldAutorotateToInterfaceOrientation(UIInterfaceOrientationPortraitUpsideDown).should == nil
  end

  it "root view should be styled as :root" do
    @root_view.stylename.should == :root
    @root_view.frame.origin.x.should == 0
    @root_view.frame.origin.y.should == 20
    @root_view.frame.size.width.should == 320
    @root_view.frame.size.height.should == 460
    @root_view.backgroundColor.should == UIColor.yellowColor
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

  it "should not have styles overridden by base classes" do
    @background.alpha.should == 0.5
  end

  it "should have styles overridden orientation styles" do
    @background.backgroundColor.should == UIColor.darkGrayColor
  end

  it "should have all UILabels with color blue" do
    @welcome.textColor.should == UIColor.blueColor
    @footer.textColor.should == UIColor.blueColor
  end

  it "should be styled as :welcome" do
    @welcome.stylename.should == :welcome
    @welcome.frame.origin.x.should == 10
    @welcome.frame.origin.y.should == 40
    @welcome.frame.size.width.should == 280
    @welcome.frame.size.height.should == 20
    @welcome.text.should == "Welcome to teacup"
  end

  it "should be styled as :footer" do
    @footer.stylename.should == :footer
    @footer.frame.origin.x.should == 10
    @footer.frame.origin.y.should == 410
    @footer.frame.size.width.should == 280
    @footer.frame.size.height.should == 20
    @footer.text.should == "This is a teacup example"
  end

  it "should be styled as :next_message" do
    @button.stylename.should == :next_message
    @button.frame.origin.x.should == 150
    @button.frame.origin.y.should == 370
    @button.frame.size.width.should == 130
    @button.frame.size.height.should == 20
    @button.titleForState(UIControlStateNormal).should == "Next Message..."
  end

end


describe "background view in landscape" do
  tests MainController

  before do
    @root_view = window.subviews[0]
    @background = @root_view.subviews[0]
    @welcome = @background.subviews[0]
    @footer = @background.subviews[1]
    @button = @background.subviews[2]
    rotate_device :to => :landscape
  end

  it "should be in landscape" do
    if UIApplication.sharedApplication.statusBarOrientation != UIInterfaceOrientationLandscapeLeft
      NSLog("\n=====\n  The device orientation is not changing to `landscape`!\n=====\n")
    end
    UIApplication.sharedApplication.statusBarOrientation.should == UIInterfaceOrientationLandscapeLeft
  end

  it "should be styled as :background - landscape" do
    @background.stylename.should == :background
    @background.frame.origin.x.should == 10
    @background.frame.origin.y.should == 30
    @background.frame.size.width.should == 460
    @background.frame.size.height.should == 280
    @background.backgroundColor.should == UIColor.lightGrayColor
  end

  it "should not have styles overridden by base classes" do
    @background.alpha.should == 0.8
  end

  it "should have styles overridden orientation styles" do
    @background.backgroundColor.should == UIColor.lightGrayColor
  end

  it "should be styled as :welcome - landscape" do
    @welcome.stylename.should == :welcome
    @welcome.frame.origin.x.should == 90
    @welcome.frame.origin.y.should == 40
    @welcome.frame.size.width.should == 280
    @welcome.frame.size.height.should == 20
    @welcome.text.should == "Welcome to teacup"
  end

  it "should be styled as :footer - landscape" do
    @footer.stylename.should == :footer
    @footer.frame.origin.x.should == 90
    @footer.frame.origin.y.should == 250
    @footer.frame.size.width.should == 280
    @footer.frame.size.height.should == 20
    @footer.text.should == "This is a teacup example"
  end

  it "should be styled as :next_message - landscape" do
    @button.stylename.should == :next_message
    @button.frame.origin.x.should == 20
    @button.frame.origin.y.should == 200
    @button.frame.size.width.should == 130
    @button.frame.size.height.should == 20
    @button.titleForState(UIControlStateNormal).should == "Next Message..."
  end

end


describe "background view in landscape" do
  tests MainController

  before do
    @root_view = window.subviews[0]
    @background = @root_view.subviews[0]
    @welcome = @background.subviews[0]
    @footer = @background.subviews[1]
    @button = @background.subviews[2]
    rotate_device :to => :landscape
    rotate_device :to => :portrait
  end

  it "should be in portrait" do
    if UIApplication.sharedApplication.statusBarOrientation != UIInterfaceOrientationPortrait
      NSLog("\n=====\n  The device orientation is not changing to `portrait`!\n=====\n")
    end
    UIApplication.sharedApplication.statusBarOrientation.should == UIInterfaceOrientationPortrait
  end

  it "root view should be styled as :root, keeping landscape properties that weren't changed" do
    @root_view.stylename.should == :root
    @root_view.backgroundColor.should == UIColor.redColor
  end

end


# this is the stylesheet used in MainController
describe "Stylesheet 'main'" do
  before do
    @stylesheet = Teacup::Stylesheet[:main]
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
    (@stylesheet.query(:next_message)[:portrait] ? true : false).should == false
  end

end
