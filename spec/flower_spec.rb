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

    it 'should place one subview correctly below another' do
      top_view = UIView.new
      top_view.position = :relative
      top_view.margins = [10, 10, 10, 10]
      top_view.size = [100, 100]
      bottom_view = UIView.new
      bottom_view.position = :relative
      Flower.new([top_view, bottom_view], CGSize.new(320, 480)).flow

      top_view.frame.origin.x.should == 10.0
      top_view.frame.origin.y.should == 10.0

      bottom_view.frame.origin.x.should == 0.0
      bottom_view.frame.origin.y.should == 120.0
    end

    it 'should place an inline block to the right of another' do
      left_view = UIView.new
      left_view.position = :relative
      left_view.margins = [10, 10, 10, 10]
      left_view.size = [100, 100]
      right_view = UIView.new
      right_view.position = :relative
      right_view.display = :inline
      right_view.size = [50,50]
      bottom_view = UIView.new
      bottom_view.position = :relative
      Flower.new([left_view, right_view, bottom_view], CGSize.new(320, 480)).flow

      left_view.frame.origin.x.should == 10.0
      left_view.frame.origin.y.should == 10.0

      right_view.frame.origin.x.should == 120.0
      right_view.frame.origin.y.should == 10.0

      bottom_view.frame.origin.x.should == 0.0
      bottom_view.frame.origin.y.should == 120.0
    end

    it 'should place an inline block to the right of another with a display block below' do
      view = UIView.new
      view.position = :relative
      view.size = [[0,UIView::MAX_SIZE], 20.0]
      Flower.new([view], CGSize.new(320, 480)).flow

      view.frame.should == CGRect.new([0.0, 0.0], [320.0, 20.0])
    end
  end
end
