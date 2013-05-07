describe "UIView getters" do

  before do
    stylesheet1 = Teacup::Stylesheet.new do
      style :parent_style
    end
    stylesheet2 = Teacup::Stylesheet.new do
      import stylesheet1
      style :extended_style, extends: :parent_style
    end

    @view = UIView.new.tap do |view|
      @some_view = view.subview(UIView, :some_view)
      @extended_style = view.subview(UIView, :extended_style)
      container = view.subview(UIView)
        @label1 = container.subview(UILabel)
        @label2 = container.subview(UILabel)
        @label3 = container.subview(UILabel)
      @stylename1 = view.subview(UIView, :stylename)
      @stylename2 = view.subview(UIView, :stylename)
      @stylename3 = view.subview(UIView, :stylename)
      container = view.subview(UIView)
        @button = container.subview(UIButton)
    end
    @view.stylesheet = stylesheet2
    @view.stylename = :self_style
  end

  describe "viewWithStylename" do
    it "should return based on stylename" do
      @view.viewWithStylename(:some_view).should == @some_view
    end

    it "should return self based on stylename" do
      @view.viewWithStylename(:self_style).should == @view
    end

    it "should return based on class" do
      @view.viewWithStylename(UIButton).should == @button
    end

    it "should return based on extended stylename" do
      @view.viewWithStylename(:extended_style).should == @extended_style
      @view.viewWithStylename(:parent_style).should == @extended_style
    end

    it "should nil when there is no match" do
      @view.viewWithStylename(:this_is_not_a_stylename).should == nil
      @view.viewWithStylename(UITableView).should == nil
    end
  end

  describe "viewsWithStylename" do
    it "should return based on stylename" do
      @view.viewsWithStylename(:stylename).should == [@stylename1, @stylename2, @stylename3]
    end

    it "should return based on class" do
      @view.viewsWithStylename(UILabel).should == [@label1, @label2, @label3]
    end

    it "should [] when there is no match" do
      @view.viewsWithStylename(:this_is_not_a_stylename).should == []
      @view.viewsWithStylename(UITableView).should == []
    end
  end

end
