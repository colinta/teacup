describe "Teacup::Style" do

  it "should be equal to a Hash" do
    Teacup::Style.new.should == {}
  end

  it "should act like a Hash" do
    style = Teacup::Style.new
    style[:key] = :value
    style[:key].should == :value
  end

  it "should use orientation to override" do
    style = Teacup::Style.new
    style[:name] = :default
    style[:landscape] = {
      name: :landscape_name,
    }
    style[:portrait] = {
      name: :portrait_name,
    }
    style[:upside_down] = {
      name: :upside_down_name,
    }
    # no orientation, which ends up being portrait anyway.
    if UIApplication.sharedApplication.statusBarOrientation == UIInterfaceOrientationPortrait
      style.build()[:name].should == :portrait_name
    else
      style.build()[:name].should == :landscape_name
    end
    # landscape
    style.build(nil, UIInterfaceOrientationLandscapeLeft)[:name].should == :landscape_name

    # upside down
    style.build(nil, UIInterfaceOrientationPortraitUpsideDown)[:name].should == :upside_down_name
  end

  it "should look in extends" do
    sheet = Teacup::Stylesheet.new do
      style :extended,
        key: :value
    end
    sheet.query(:extended)[:key].should == :value

    style = Teacup::Style.new
    style.stylename = :self
    style.stylesheet = sheet
    style[:extends] = :extended
    style.build()[:key].should == :value
  end

  it "should look in import" do
    imported_sheet = Teacup::Stylesheet.new do
      style :extended,
        imported: :imported,
        override: :overridden
    end

    sheet = Teacup::Stylesheet.new do
      import imported_sheet

      style :extended,
        key: :value,
        override: :override
    end
    sheet.query(:extended)[:key].should == :value
    sheet.query(:extended)[:imported].should == :imported
    sheet.query(:extended)[:override].should == :override
  end

  it 'should merge :extends properties' do
    sheet = Teacup::Stylesheet.new do
      style :style1,
        a: 'a',
        b: 'b'
    end
    style2 = Teacup::Style.new
    style2.stylesheet = sheet
    style2[:a] = 'A'
    style2[:extends] = :style1

    built = style2.build()
    built[:a].should == 'A'
    built[:b].should == 'b'
  end

  it 'should merge hashes' do
    sheet = Teacup::Stylesheet.new do
      style :style1,
        layer: { borderWidth: 20, opacity: 0.5 }
    end

    style2 = Teacup::Style.new
    style2.stylesheet = sheet
    style2[:layer] = { borderWidth: 10 }
    style2[:extends] = :style1

    built = style2.build()
    built[:layer][:opacity].should == 0.5
    built[:layer][:borderWidth].should == 10
  end

  it 'should merge multiple extends' do
    sheet = Teacup::Stylesheet.new do
      style :style1,
        layer: { borderWidth: 20 }
      style :style2,
        layer: { borderWidth: 10, opacity: 0.5 }
    end

    style3 = Teacup::Style.new
    style3.stylesheet = sheet
    style3[:extends] = [:style1, :style2]

    built = style3.build()
    built[:layer][:opacity].should == 0.5
    built[:layer][:borderWidth].should == 20
  end

  it 'should merge and flatten orientation rules' do
    sheet = Teacup::Stylesheet.new do
      style :style1,
        portrait: { text: "ignored", tag: 1 }
    end

    style2 = Teacup::Style.new
    style2.stylesheet = sheet
    style2[:portrait] = { text: "text" }
    style2[:extends] = :style1

    built = style2.build(nil, UIInterfaceOrientationPortrait)
    built[:tag].should == 1
    built[:text].should == "text"
  end

  it 'should respect precedence rules' do
    sheet = Teacup::Stylesheet.new do
      style :style1,
        landscape: { tag: 1 },
        portrait: { text: "extended", tag: 1 }
    end

    style2 = Teacup::Style.new
    style2.stylesheet = sheet
    style2[:text] = "text"
    style2[:extends] = :style1

    built = style2.build(nil)
    built[:tag].should == 1
    built[:text].should == 'text'

    built = style2.build(nil, UIInterfaceOrientationPortrait)
    built[:tag].should == 1
    built[:text].should == nil
  end

  it 'should respect merge based on class inheritance' do
    class Foo
      attr_accessor :bar
    end

    class Bar < Foo
      attr_accessor :baz
    end

    sheet = Teacup::Stylesheet.new do
      style Foo,
        bar: 'bar'
    end

    style = Teacup::Style.new
    style.stylesheet = sheet
    style[:baz] = 'baz'

    built = style.build(Bar.new)
    built[:bar].should == 'bar'
    built[:baz].should == 'baz'
  end

end
