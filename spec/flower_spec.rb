describe "Flower" do
  describe 'simple layout' do
    it 'should place one subview correctly' do
      view = UIView.new
      view.position = :relative
      view.margins = [10, 10, 10, 10]
      Flower.new([view], CGSize.new(320, 480)).flow
      
      view.frame.origin.x.should == 10.0
      view.frame.origin.y.should == 10.0
    end
  end
end
