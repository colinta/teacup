describe "Any class that includes Teacup::Layout" do
  before do
    @subject = CustomTeacupClass.new
  end

  it "should be able to have a stylesheet" do
    @subject.stylesheet.class.should == Teacup::Stylesheet
  end

  it "should be able to layout and create views" do
    @subject.create_container.should != nil
  end

  it "should have a container and label that are styled" do
    container = @subject.create_container
    container.frame.size.width.should == 100
    container.frame.size.height.should == 20
    container.subviews.length.should == 1
    label = container.subviews[0]
    label.text.should == 'custom label'
  end

end
