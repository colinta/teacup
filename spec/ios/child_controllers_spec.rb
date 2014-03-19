describe 'Child view controllers' do
  tests RootViewController

  it 'should have the correct color' do
    @controller.child_controller.view.backgroundColor.should == UIColor.yellowColor
  end

end