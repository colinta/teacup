describe "TableViewCells" do
  tests TableViewController

  before do
    @path = NSIndexPath.indexPathWithIndex(0).indexPathByAddingIndex(0)
    @cell = controller.view.cellForRowAtIndexPath(@path)
    @padding = @cell.contentView.subviews[0]
  end

  it "should have styled padding" do
    @padding.backgroundColor.should == UIColor.greenColor
    @padding.center.x.should == @padding.superview.bounds.size.width / 2
    @padding.center.y.should == @padding.superview.bounds.size.height / 2
    @padding.frame.size.width.should < @padding.superview.bounds.size.width
    @padding.frame.size.height.should < @padding.superview.bounds.size.height
  end

  it "should have styled title" do
    @cell.title_label.text.should =~ /^title/
    @cell.title_label.frame.origin.x.should == 0
    @cell.title_label.frame.origin.y.should == 0
    @cell.title_label.frame.size.height.should == 20
    @cell.title_label.frame.size.width.should == @padding.frame.size.width
    @cell.title_label.textColor.should == UIColor.blueColor
  end

  it "should have styled details" do
    @cell.details_label.text.should =~ /^details/
    @cell.details_label.frame.origin.x.should == 0
    @cell.details_label.frame.origin.y.should == CGRectGetMaxY(@cell.title_label.frame) + 5
    @cell.details_label.frame.size.height.should == 17
    @cell.details_label.frame.size.width.should == @padding.frame.size.width
  end

  it "should have styled other" do
    @cell.other_label.text.should =~ /^other/
    @cell.other_label.frame.origin.x.should == 0
    @cell.other_label.frame.origin.y.should == CGRectGetMaxY(@cell.details_label.frame) + 5
    @cell.other_label.frame.size.height.should == 17
    @cell.other_label.frame.size.width.should == @padding.frame.size.width
  end

end
