describe 'Styling a modal view' do
  tests PresentModalController

  it 'should work' do
    tap 'Open Modal'
    @controller.modal.view.backgroundColor.should == UIColor.blackColor
  end

end
