describe "Teacup::Stylesheet" do

  describe "Limelight-style syntax" do
    before do
      @limelight = Teacup::Stylesheet.new :most_generic do
        label {
          backgroundColor :blue
          title 'In the lime light'
        }

        button {
          title 'Click Here!'
          layer {
            color :blue
          }
        }
      end
    end

    it "should have styles" do
      @limelight.query(:label)[:backgroundColor].should == :blue
      @limelight.query(:label)[:title].should == 'In the lime light'
      @limelight.query(:button)[:title].should == 'Click Here!'
      @limelight.query(:button)[:layer][:color].should == :blue
    end
  end
end
