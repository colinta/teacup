describe "Layouts" do

  it "Should be applied to UIView" do
    subject = UIView.new
    subject.respond_to?(:subview).should == true
    subject.respond_to?(:layout).should == true
  end

  it "Should be applied to UIViewController" do
    subject = UIViewController.new
    subject.respond_to?(:subview).should == true
    subject.respond_to?(:layout).should == true
  end

  it "Should add a subview to a UIView" do
    subject = UIView.new
    subject.subviews.length.should == 0
    subject.subview(UIView)
    subject.subviews.length.should == 1
  end

  it "Should add a subview to a UIViewController" do
    subject = UIViewController.new
    subject.view.subviews.length.should == 0
    subject.subview(UIView)
    subject.view.subviews.length.should == 1
  end

  it "Should apply styles" do
    subject = UIView.new
    view = subject.subview(UIView, tag: 1)
    view.tag.should == 1
  end

  it "Should allow multiple calls" do
    subject = UIView.new
    view = subject.subview(UIView, tag: 1)
    subject.layout(view, tag: 2)
    view.tag.should == 2
  end

  it "Should merge hashes, like a stylesheet does" do
    subject = UIView.new
    view = subject.subview(UIView, layer: { opacity: 0.5 })
    subject.layout(view, layer: { shadowRadius: 3 })
    view.layer.opacity.should == 0.5
    view.layer.shadowRadius.should == 3
  end

end
