describe "Stylesheet - Autoresize" do

  it "should return the same object" do
    stylesheet1 = Teacup::Stylesheet.new
    stylesheet2 = Teacup::Stylesheet.new
    stylesheet1.autoresize.should == stylesheet2.autoresize
  end

  it "should return autoresizeMask values" do
    stylesheet = Teacup::Stylesheet.new

    stylesheet.autoresize.flexible_left.should == UIViewAutoresizingFlexibleLeftMargin
    stylesheet.autoresize.flexible_width.should == UIViewAutoresizingFlexibleWidth
    stylesheet.autoresize.flexible_right.should == UIViewAutoresizingFlexibleRightMargin
    stylesheet.autoresize.flexible_top.should == UIViewAutoresizingFlexibleTopMargin
    stylesheet.autoresize.flexible_height.should == UIViewAutoresizingFlexibleHeight
    stylesheet.autoresize.flexible_bottom.should == UIViewAutoresizingFlexibleBottomMargin
  end

  it "should return autoresizeMask values" do
    stylesheet = Teacup::Stylesheet.new

    stylesheet.autoresize.fill.should == UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    stylesheet.autoresize.fill_top.should == UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin
    stylesheet.autoresize.fill_bottom.should == UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin
    stylesheet.autoresize.fill_left.should == UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin
    stylesheet.autoresize.fill_right.should == UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin

    stylesheet.autoresize.fixed_top_left.should == UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin
    stylesheet.autoresize.fixed_top_middle.should == UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin
    stylesheet.autoresize.fixed_top_right.should == UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin
    stylesheet.autoresize.fixed_middle_left.should == UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin
    stylesheet.autoresize.fixed_middle.should == UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    stylesheet.autoresize.fixed_middle_right.should == UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin
    stylesheet.autoresize.fixed_bottom_left.should == UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin
    stylesheet.autoresize.fixed_bottom_middle.should == UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin
    stylesheet.autoresize.fixed_bottom_right.should == UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin

    stylesheet.autoresize.float_horizontal.should == UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    stylesheet.autoresize.float_vertical.should == UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
  end

  it "should combine values in a block" do
    stylesheet = Teacup::Stylesheet.new

    stylesheet.autoresize { flexible_left | flexible_width }.should == UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth
    stylesheet.autoresize { flexible_width | flexible_height }.should == UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
  end

end
