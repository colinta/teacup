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

describe 'extends merges constraints' do
  before do
    Teacup::Stylesheet.stylesheets[:merge_constraints] = nil
    Teacup::Stylesheet.new(:merge_constraints) do
      style :button,
        constraints: [
          :full_width,
          constrain_height(22),
          constrain_top(0)
        ]

      style :tall_button, extends: :button,
        constraints: [
          constrain_width(100),
          constrain_height(44),
        ]
    end
  end

  it 'should not affect "base class" style' do
    merge_constraints_stylesheet = Teacup::Stylesheet[:merge_constraints]
    button_style = merge_constraints_stylesheet.query(:button)
    button_style[:constraints].size.should == 3

    full_constraint = button_style[:constraints][0]
    height_constraint = button_style[:constraints][1]
    top_constraint = button_style[:constraints][2]

    full_constraint.should == :full_width
    height_constraint.attribute.should == Teacup::Constraint::Attributes[:height]
    height_constraint.constant.should == 22
    top_constraint.attribute.should == Teacup::Constraint::Attributes[:top]
    top_constraint.constant.should == 0
  end

  it 'should merge constraints when extending styles' do
    merge_constraints_stylesheet = Teacup::Stylesheet[:merge_constraints]
    tall_button_style = merge_constraints_stylesheet.query(:tall_button)
    tall_button_style[:constraints].size.should == 4

    width_constraint = tall_button_style[:constraints][0]
    height_constraint = tall_button_style[:constraints][1]
    center_x_constraint = tall_button_style[:constraints][2]
    top_constraint = tall_button_style[:constraints][3]

    width_constraint.attribute.should == Teacup::Constraint::Attributes[:width]
    width_constraint.constant.should == 100
    height_constraint.attribute.should == Teacup::Constraint::Attributes[:height]
    height_constraint.constant.should == 44
    center_x_constraint.attribute.should == Teacup::Constraint::Attributes[:center_x]
    center_x_constraint.attribute2.should == Teacup::Constraint::Attributes[:center_x]
    rel_to = center_x_constraint.relative_to
    # nil is a valid value for :superview
    rel_to ||= :superview
    rel_to.should == :superview
    top_constraint.attribute.should == Teacup::Constraint::Attributes[:top]
    top_constraint.constant.should == 0
  end
end
