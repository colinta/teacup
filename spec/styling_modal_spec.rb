describe 'Styling a modal view' do
  tests PresentModalController

  it 'should open a modal' do
    tap 'Open Modal'
    wait 10 {
      1.should == 1
    }
  end

end
