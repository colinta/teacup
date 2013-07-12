describe "TableViewCells" do
  tests TableViewController

  describe "Style tests on cell[0]" do
    before do
      path = NSIndexPath.indexPathWithIndex(0).indexPathByAddingIndex(0)
      @cell = controller.view.cellForRowAtIndexPath(path)
      @padding = @cell.contentView.subviews[0]
    end

    it "should have styled padding (backgroundColor.should)" do
      @padding.backgroundColor.should == UIColor.greenColor
    end
    it "should have styled padding (center.x.should)" do
      @padding.center.x.round.should == (@padding.superview.bounds.size.width / 2).round
    end
    it "should have styled padding (center.y.should)" do
      @padding.center.y.round.should == (@padding.superview.bounds.size.height / 2).round
    end
    it "should have styled padding (frame.size.width.should)" do
      @padding.frame.size.width.should < @padding.superview.bounds.size.width
    end
    it "should have styled padding (frame.size.height.should)" do
      @padding.frame.size.height.should < @padding.superview.bounds.size.height
    end

    it "should have styled title (text)" do
      @cell.title_label.text.should =~ /^title/
    end
    it "should have styled title (frame.origin.x)" do
      @cell.title_label.frame.origin.x.should == 0
    end
    it "should have styled title (frame.origin.y)" do
      @cell.title_label.frame.origin.y.should == 0
    end
    it "should have styled title (frame.size.height)" do
      @cell.title_label.frame.size.height.should == 20
    end
    it "should have styled title (frame.size.width)" do
      @cell.title_label.frame.size.width.should == @padding.frame.size.width
    end
    it "should have styled title (textColor)" do
      @cell.title_label.textColor.should == UIColor.blueColor
    end

    it "should have styled details (text)" do
      @cell.details_label.text.should =~ /^details/
    end
    it "should have styled details (frame.origin.x)" do
      @cell.details_label.frame.origin.x.should == 0
    end
    it "should have styled details (frame.origin.y)" do
      @cell.details_label.frame.origin.y.should == CGRectGetMaxY(@cell.title_label.frame) + 5
    end
    it "should have styled details (frame.size.height)" do
      @cell.details_label.frame.size.height.should == 17
    end
    it "should have styled details (frame.size.width)" do
      @cell.details_label.frame.size.width.should == @padding.frame.size.width
    end

    it "should have styled other (text)" do
      @cell.other_label.text.should =~ /^other/
    end
    it "should have styled other (frame.origin.x)" do
      @cell.other_label.frame.origin.x.should == 0
    end
    it "should have styled other (frame.origin.y)" do
      @cell.other_label.frame.origin.y.should == CGRectGetMaxY(@cell.details_label.frame) + 5
    end
    it "should have styled other (frame.size.height)" do
      @cell.other_label.frame.size.height.should == 17
    end
    it "should have styled other (frame.size.width)" do
      @cell.other_label.frame.size.width.should == @padding.frame.size.width
    end

  end

  describe "Style tests on cell[9]" do
    before do
      path = NSIndexPath.indexPathWithIndex(0).indexPathByAddingIndex(9)
      controller.view.scrollToRowAtIndexPath(path, atScrollPosition:UITableViewScrollPositionBottom, animated:false)
      @cell = controller.view.cellForRowAtIndexPath(path)
      @padding = @cell.contentView.subviews[0]
    end

    it "should be a reused cell" do
      @cell.is_reused.should == true
    end

    it "should have styled padding (backgroundColor)" do
      @padding.backgroundColor.should == UIColor.greenColor
    end
    it "should have styled padding (center.x)" do
      @padding.center.x.round.should == (@padding.superview.bounds.size.width / 2).round
    end
    it "should have styled padding (center.y)" do
      @padding.center.y.round.should == (@padding.superview.bounds.size.height / 2).round
    end
    it "should have styled padding (frame.size.width)" do
      @padding.frame.size.width.should < @padding.superview.bounds.size.width
    end
    it "should have styled padding (frame.size.height)" do
      @padding.frame.size.height.should < @padding.superview.bounds.size.height
    end

    it "should have styled title (text)" do
      @cell.title_label.text.should =~ /^title/
    end
    it "should have styled title (frame.origin.x)" do
      @cell.title_label.frame.origin.x.should == 0
    end
    it "should have styled title (frame.origin.y)" do
      @cell.title_label.frame.origin.y.should == 0
    end
    it "should have styled title (frame.size.height)" do
      @cell.title_label.frame.size.height.should == 20
    end
    it "should have styled title (frame.size.width)" do
      @cell.title_label.frame.size.width.should == @padding.frame.size.width
    end
    it "should have styled title (textColor)" do
      @cell.title_label.textColor.should == UIColor.blueColor
    end

    it "should have styled details (text)" do
      @cell.details_label.text.should =~ /^details/
    end
    it "should have styled details (frame.origin.x)" do
      @cell.details_label.frame.origin.x.should == 0
    end
    it "should have styled details (frame.origin.y)" do
      @cell.details_label.frame.origin.y.should == CGRectGetMaxY(@cell.title_label.frame) + 5
    end
    it "should have styled details (frame.size.height)" do
      @cell.details_label.frame.size.height.should == 17
    end
    it "should have styled details (frame.size.width)" do
      @cell.details_label.frame.size.width.should == @padding.frame.size.width
    end

    it "should have styled other (text)" do
      @cell.other_label.text.should =~ /^other/
    end
    it "should have styled other (frame.origin.x)" do
      @cell.other_label.frame.origin.x.should == 0
    end
    it "should have styled other (frame.origin.y)" do
      @cell.other_label.frame.origin.y.should == CGRectGetMaxY(@cell.details_label.frame) + 5
    end
    it "should have styled other (frame.size.height)" do
      @cell.other_label.frame.size.height.should == 17
    end
    it "should have styled other (frame.size.width)" do
      @cell.other_label.frame.size.width.should == @padding.frame.size.width
    end

  end

end
