describe 'Presenting a modal view' do
  tests PresentModalController

  it 'should style the view' do
    tap 'Open Modal'
    @controller.modal.view.accessibilityLabel.should == 'root view'
  end

end
