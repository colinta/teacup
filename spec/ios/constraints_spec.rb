##|
##|  PORTRAIT
##|
describe 'Using constraints in portrait' do
  tests ConstraintsController

  it 'should have a header view' do
    @controller.header_view.frame.tap do |f|
      f.origin.x.should == 0
      f.origin.y.should == 0
      f.size.width.should == @controller.container.frame.size.width
      f.size.height.should == 52
    end
  end

  it 'should have a footer view' do
    @controller.footer_view.frame.tap do |f|
      f.origin.x.should == 0
      (f.origin.y + f.size.height).should == @controller.container.frame.size.height
      f.size.width.should == @controller.container.frame.size.width
      f.size.height.should == 52
    end
  end

  it 'should have a top_layout_view' do
    @controller.top_layout_view.frame.tap do |f|
      f.origin.x.should == 0
      f.origin.y.should == @controller.topLayoutGuide.length
    end
  end

  it 'should have a bottom_layout_view' do
    @controller.bottom_layout_view.frame.tap do |f|
      f.origin.x.should == 0
      f.origin.y.should == @controller.container.frame.size.height - @controller.bottomLayoutGuide.length - 10
    end
  end

  it 'should have a center view' do
    @controller.center_view.frame.tap do |f|
      f.origin.x.should == 8
      f.origin.y.should == @controller.header_view.frame.size.height + 8
      f.size.width.should == @controller.container.frame.size.width - 16
      f.size.height.should == @controller.container.frame.size.height - 120
    end
  end

  it 'should have a left view' do
    @controller.left_view.frame.tap do |f|
      f.origin.x.should == 8
      f.origin.y.should == 8
      f.size.width.should == @controller.center_view.frame.size.width / 2 - 12
      f.size.height.should == @controller.center_view.frame.size.height - 16
    end
  end

  it 'should have a top_right view' do
    @controller.top_right_view.frame.tap do |f|
      f.origin.x.should == @controller.center_view.frame.size.width / 2 + 4
      f.origin.y.should == 8
      f.size.width.should == @controller.left_view.frame.size.width
      f.size.height.should == @controller.left_view.frame.size.height / 2 - 4
    end
  end

  it 'should have a btm_right view' do
    @controller.btm_right_view.frame.tap do |f|
      f.origin.x.should == @controller.center_view.frame.size.width / 2 + 4
      f.origin.y.should == @controller.center_view.frame.size.height / 2 + 4
      f.size.width.should == @controller.left_view.frame.size.width
      f.size.height.should == @controller.top_right_view.frame.size.height
    end
  end

end

##|
##|  LANDSCAPE
##|
describe 'Using constraints in landscape' do
  tests ConstraintsController

  before do
    rotate_device :to => :landscape
  end

  after do
    rotate_device :to => :portrait
  end

  it 'should have a header view' do
    @controller.header_view.frame.tap do |f|
      f.origin.x.should == 0
      f.origin.y.should == 0
      f.size.width.should == @controller.container.frame.size.width
      f.size.height.should == 52
    end
  end

  it 'should have a footer view' do
    @controller.footer_view.frame.tap do |f|
      f.origin.x.should == 0
      (f.origin.y + f.size.height).should == @controller.container.frame.size.height
      f.size.width.should == @controller.container.frame.size.width
      f.size.height.should == 52
    end
  end

  it 'should have a center view' do
    @controller.center_view.frame.tap do |f|
      f.origin.x.should == 8
      f.origin.y.should == @controller.header_view.frame.size.height + 8
      f.size.width.should == @controller.container.frame.size.width - 16
      f.size.height.should == @controller.container.frame.size.height - 120
    end
  end

  it 'should have a left view' do
    @controller.left_view.frame.tap do |f|
      f.origin.x.should == 8
      f.origin.y.should == 8
      f.size.width.should == @controller.center_view.frame.size.width / 2 - 12
      f.size.height.should == @controller.center_view.frame.size.height - 16
    end
  end

  it 'should have a top_right view' do
    @controller.top_right_view.frame.tap do |f|
      f.origin.x.should == @controller.center_view.frame.size.width / 2 + 4
      f.origin.y.should == 8
      f.size.width.should == @controller.left_view.frame.size.width
      f.size.height.should == @controller.left_view.frame.size.height / 2 - 4
    end
  end

  it 'should have a btm_right view' do
    @controller.btm_right_view.frame.tap do |f|
      f.origin.x.should == @controller.center_view.frame.size.width / 2 + 4
      f.origin.y.should == @controller.center_view.frame.size.height / 2 + 4
      f.size.width.should == @controller.left_view.frame.size.width
      f.size.height.should == @controller.top_right_view.frame.size.height
    end
  end

end
