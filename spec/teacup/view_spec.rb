require 'spec_helper'

describe "Teacup::View" do

  before do
    @mock = Object.new.tap do |o|
      o.extend Teacup::View

      def o.subviews
        @subviews ||= []
      end

      def o.layer
        @layer ||= Object.new
      end
    end

    @stylesheet = Teacup::Stylesheet.new do
      style :label,
        text: "Stylesheet1 Label1"
    end
  end

  describe 'stylename=' do
    it 'should work' do
      @mock.should_not_receive(:style).with(text: "Stylesheet1 Label1")
      @mock.stylename = :label

      @mock.stylename.should == :label
    end

    it 'should set the style when a stylesheet is there' do
      @mock.stylesheet = @stylesheet
      @mock.should_receive(:style).with(text: "Stylesheet1 Label1")
      @mock.stylename = :label

      @mock.stylename.should == :label
    end
  end

  describe 'stylesheet=' do
    it 'should work' do
      @mock.should_not_receive(:style).with(text: "Stylesheet1 Label1")
      @mock.stylesheet = @stylesheet

      @mock.stylesheet.should == @stylesheet
    end

    it 'should set the style when a stylename is there' do
      @mock.stylename = :label
      @mock.should_receive(:style).with(text: "Stylesheet1 Label1")
      @mock.stylesheet = @stylesheet

      @mock.stylesheet.should == @stylesheet
    end

    it 'should push the stylesheet down to all subviews' do
      listener = Object.new
      listener.should_receive(:stylesheet=).with(@stylesheet)
      @mock.subviews << listener
      @mock.stylesheet = @stylesheet
    end
  end

  describe 'style' do
    # WARNING: I'm relying on the fact that 'should_receive(:foo)'
    # defines a method.

    it 'should convert left/top/width/height into frame' do
      @mock.should_receive(:frame).and_return([[0,0], [0,0]])
      @mock.should_receive(:frame=).with([[1,2], [3,4]])
      @mock.style(left: 1, top: 2, width: 3, height: 4)
    end

    it 'should assign any random property that works' do
      @mock.should_receive(:partyTime=).with(:always)
      @mock.style(partyTime: :always)
    end

    it 'should assign any random property that works on the layer' do
      @mock.layer.should_receive(:borderRadius=).with(10)
      @mock.style(borderRadius: 10)
    end

    it 'should warn about unknown thingies' do
      $stderr.should_receive(:puts).and_return{ |foo|
        foo.should =~ /Teacup WARN:.*barbaric/
      }
      @mock.style(barbaric: "Beards")
    end
  end
end
