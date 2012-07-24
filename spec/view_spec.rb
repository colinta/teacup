describe "Teacup::View" do

  before do
    @view = UILabel.new

    @stylesheet = Teacup::Stylesheet.new do
      style :label,
        text: "Stylesheet1 Label1"
    end
  end

  describe 'stylename=' do
    it 'should work' do
      @view.stylename = :label
      @view.stylename.should == :label
    end

    it 'should set the style when a stylesheet is there' do
      @view.stylesheet = @stylesheet
      @view.stylename = :label

      @view.stylename.should == :label
      @view.text.should == "Stylesheet1 Label1"
    end
  end

  describe 'stylesheet=' do
    it 'should work' do
      @view.stylesheet = @stylesheet
      @view.stylesheet.should == @stylesheet
    end

    it 'should set the style when a stylename is there' do
      @view.stylename = :label
      @view.stylesheet = @stylesheet

      @view.text.should == "Stylesheet1 Label1"
    end

    it 'should push the stylesheet down to all subviews' do
      listener = UIView.new
      @view.addSubview(listener)
      @view.stylesheet = @stylesheet
      listener.stylesheet.should == @stylesheet
    end
  end

  describe 'import' do
    before do
      @import_view = UIView.new

      Teacup::Stylesheet.new :to_import do
        style :view,
          top: 20,
          portrait: {
            top: 30
          }
      end

      @import_stylesheet = Teacup::Stylesheet.new do
        import :to_import

        style :view,
          top: 40
      end
    end

    it 'should always prefer more local styles' do
      @import_view.stylename = :view
      @import_view.stylesheet = @import_stylesheet

      @import_view.restyle!(orientation=UIInterfaceOrientationPortrait)
      @import_view.frame.origin.y.should == 40
    end
  end

  describe 'style' do

    it 'should assign any random property that works' do
      @view.style(tag: 1)
      @view.tag.should == 1
    end

    it 'should convert left/top/width/height into frame' do
      @view.style(left: 1, top: 2, width: 3, height: 4)
      @view.frame.origin.x.should == 1
      @view.frame.origin.y.should == 2
      @view.frame.size.width.should == 3
      @view.frame.size.height.should == 4
    end

    it 'should assign any random property that works on the layer' do
      @view.style(layer: { borderWidth: 10 })
      @view.layer.borderWidth.should == 10
    end

    it 'should warn about unknown thingies' do
      @view.style(partyTime: :excellent)
    end

  end

end
