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
      top_view.dimensions = [100, 100]
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
      left_view.dimensions = [100, 100]
      right_view = UIView.new
      right_view.position = :relative
      right_view.display = :inline
      right_view.dimensions = [50,50]
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

    it 'should make this view the entire width' do
      view = UIView.new
      view.position = :relative
      view.dimensions = [UIView::MAX_DIMENSION, 20.0]
      Flower.new([view], CGSize.new(320, 480)).flow

      view.frame.should == CGRect.new([0.0, 0.0], [320.0, 20.0])
    end

    it 'should make this view the entire width minus the margins' do
      view = UIView.new
      view.position = :relative
      view.margins = [10.0, 10.0, 0.0, 0.0]
      view.dimensions = [UIView::MAX_DIMENSION, 20.0]
      Flower.new([view], CGSize.new(320, 480)).flow

      view.frame.should == CGRect.new([10.0, 0.0], [300.0, 20.0])
    end

    it 'make the left view stretch all the way to the right view of fixed size' do
      left_view = UIView.new
      left_view.position = :relative
      left_view.display = :inline
      left_view.dimensions = [UIView::MAX_DIMENSION, 20.0]
      right_view = UIView.new
      right_view.position = :relative
      right_view.display = :inline
      right_view.dimensions = [100.0, 20.0]
      Flower.new([left_view, right_view], CGSize.new(320, 480)).flow

      left_view.frame.should == CGRect.new([0.0, 0.0], [220.0, 20.0])
      right_view.frame.should == CGRect.new([220.0, 0.0], [100.0, 20.0])
    end

    it 'should make this view the entire height' do
      view = UIView.new
      view.position = :relative
      view.dimensions = [20.0, UIView::MAX_DIMENSION]
      Flower.new([view], CGSize.new(320, 480)).flow

      view.frame.should == CGRect.new([0.0, 0.0], [20.0, 480.0])
    end

    it 'should make this view the entire height minus the margins' do
      view = UIView.new
      view.position = :relative
      view.margins = [0.0, 0.0, 10.0, 10.0]
      view.dimensions = [20.0, UIView::MAX_DIMENSION]
      Flower.new([view], CGSize.new(320, 480)).flow

      view.frame.should == CGRect.new([0.0, 10.0], [20.0, 460.0])
    end

    it 'make the top view stretch all the way to the bottom view of fixed size' do
      top_view = UIView.new
      top_view.position = :relative
      top_view.display = :block
      top_view.dimensions = [20.0, UIView::MAX_DIMENSION]
      bottom_view = UIView.new
      bottom_view.position = :relative
      bottom_view.display = :block
      bottom_view.dimensions = [UIView::MAX_DIMENSION, 20.0]
      Flower.new([top_view, bottom_view], CGSize.new(320, 480)).flow

      top_view.frame.should == CGRect.new([0.0, 0.0], [20.0, 460.0])
      bottom_view.frame.should == CGRect.new([0.0, 460.0], [320.0, 20.0])
    end

    it 'make the middle view stretch between the top and bottom views of fixed size' do
      top_view = UIView.new
      top_view.position = :relative
      top_view.display = :block
      top_view.dimensions = [100.0, 20.0]
      middle_view = UIView.new
      middle_view.position = :relative
      middle_view.display = :block
      middle_view.dimensions = [100.0, UIView::MAX_DIMENSION]
      bottom_view = UIView.new
      bottom_view.position = :relative
      bottom_view.display = :block
      bottom_view.dimensions = [100.0, 20.0]
      Flower.new([top_view, middle_view, bottom_view], CGSize.new(320, 480)).flow

      top_view.frame.should == CGRect.new([0.0, 0.0], [100.0, 20.0])
      middle_view.frame.should == CGRect.new([0.0, 20.0], [100.0, 440.0])
      bottom_view.frame.should == CGRect.new([0.0, 460.0], [100.0, 20.0])
    end

    it 'should place one subview correctly when using max dimensions' do
      view = UIView.new
      view.position = :relative
      view.dimensions = UIView::MAX_DIMENSIONS
      Flower.new([view], CGSize.new(320, 480)).flow
      
      view.frame.should == CGRect.new([0.0, 0.0], [320.0, 480.0])
    end
=begin
    it 'make the middle view stretch between the top and bottom views of fixed size' do
      top_view = UIView.new
      top_view.position = :relative
      top_view.display = :block
      top_view.dimensions = [UIView::MAX_DIMENSION, 20.0]
      middle_view = UIView.new
      middle_view.position = :relative
      middle_view.display = :block
      middle_view.dimensions = [UIView::MAX_DIMENSION, UIView::MAX_DIMENSION]
      bottom_view = UIView.new
      bottom_view.position = :relative
      bottom_view.display = :block
      bottom_view.dimensions = [UIView::MAX_DIMENSION, 20.0]
debug_this do
      Flower.new([top_view, middle_view, bottom_view], CGSize.new(320, 480)).flow
end

      top_view.frame.should == CGRect.new([0.0, 0.0], [320.0, 20.0])
      middle_view.frame.should == CGRect.new([0.0, 20.0], [320.0, 440.0])
      bottom_view.frame.should == CGRect.new([0.0, 460.0], [320.0, 20.0])
    end
=end
  end
end
