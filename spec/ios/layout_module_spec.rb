class SomeHelperClass
  include Teacup::Layout

  attr :container, :label

  stylesheet :helper_stylesheet

  def create_views
    @container = layout(UIView) do
      @label = layout(UILabel)
    end
  end

end


Teacup::Stylesheet.new :helper_stylesheet do
end

Teacup::Stylesheet.new :custom_stylesheet do
end

describe 'Layout module' do

  before do
    @helper = SomeHelperClass.new
    @stylesheet = Teacup::Stylesheet[:helper_stylesheet]
    @custom_stylesheet = Teacup::Stylesheet[:custom_stylesheet]
  end

  it 'should return class stylesheet method' do
    @helper.stylesheet.should == @stylesheet
  end

  it 'should allow custom stylesheet' do
    @helper.stylesheet = :custom_stylesheet
    @helper.stylesheet.should == @custom_stylesheet
  end

  it 'should custom and class stylesheets' do
    another_helper = SomeHelperClass.new
    another_helper.stylesheet = :custom_stylesheet

    @helper.stylesheet.should == @stylesheet
    another_helper.stylesheet.should == @custom_stylesheet
  end

  it 'should have view-creation methods' do
    @helper.create_views
    @helper.container.should.is_a?(UIView)
    @helper.label.should.is_a?(UILabel)
  end

end
