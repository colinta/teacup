class Viewish
  def superview
    @superview ||= self.class.new
  end

  def bounds
    CGRect.new([0, 0,], [100, 44])
  end
end

class IrregularBounds < Viewish
  def bounds
    CGRect.new([0, 0], [101, 43])
  end
end


describe 'Teacup.calculate' do

  it 'should return static numbers' do
    Teacup.calculate(nil, nil, 1).should == 1
  end

  it 'should call blocks' do
    a = 'hi!'
    Teacup.calculate(a, nil, ->{
      self.should == a
      2
    }).should == 2
  end

  it 'should return percents with :width' do
    Teacup.calculate(Viewish.new, :width, '50%').should == 50
  end

  it 'should return percents with :height' do
    Teacup.calculate(Viewish.new, :height, '50%').should == 22
  end

  it "should round to the nearest point" do
    Teacup.calculate(IrregularBounds.new, :height, '25%').should == 11
    Teacup.calculate(IrregularBounds.new, :width, '25%').should == 25
  end

  describe 'should return percents with offset' do
    it ':width, 50% + 10' do
      Teacup.calculate(Viewish.new, :width, '50% + 10').should == 60
    end
    it ':width, 50% - 10' do
      Teacup.calculate(Viewish.new, :width, '50% - 10').should == 40
    end
    it ':width, 25% + 5' do
      Teacup.calculate(Viewish.new, :width, '25% + 5').should == 30
    end
    it ':height, 50% + 10' do
      Teacup.calculate(Viewish.new, :height, '50% + 10').should == 32
    end
    it ':height, 50% - 10' do
      Teacup.calculate(Viewish.new, :height, '50% - 10').should == 12
    end
    it ':height, 25% + 5' do
      Teacup.calculate(Viewish.new, :height, '25% + 5').should == 16
    end
  end

end
