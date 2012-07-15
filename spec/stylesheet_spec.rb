
describe "Teacup::Stylesheet" do

  describe 'creation' do
    before do
      @stylesheet = Teacup::Stylesheet.new(:constanttest) { }
    end

    after do
      Teacup::Stylesheet.stylesheets.delete(:constanttest)
    end

    it 'should create constants for named stylesheets' do
      Teacup::Stylesheet[:constanttest].should == @stylesheet
    end

    it 'should allow creating anonymous stylesheets' do
      stylesheet = Teacup::Stylesheet.new { }
      stylesheet.name.should == nil
    end
  end

  describe 'in the simplest cases' do
    before do
      @stylesheet = Teacup::Stylesheet.new do
        style :example_button,
          frame: [[0, 0], [100, 100]]

        style :example_label, :example_textfield,
          backgroundColor: :blue
      end
    end

    it 'should let you properties for a stylename' do
      @stylesheet.query(:example_button)[:frame].should == [[0, 0], [100, 100]]
    end

    it 'should let you define properties for many stylenames' do
      @stylesheet.query(:example_label)[:backgroundColor].should == :blue
      @stylesheet.query(:example_textfield)[:backgroundColor].should == :blue
    end

    it 'should return {} for unknown stylenames' do
      @stylesheet.query(:dingbats).should == {}
    end
  end

  describe 'with multiple rules for the same stylename' do
    before do
      @stylesheet = Teacup::Stylesheet.new do
        style :example_button,
          title: "Example!",
          frame: [[0, 0], [100, 100]]

        style :example_button,
          backgroundColor: :blue,
          frame: [[100, 100], [200, 200]]
      end
    end

    it 'should union different properties' do
      @stylesheet.query(:example_button)[:title].should == "Example!"
      @stylesheet.query(:example_button)[:backgroundColor].should == :blue
    end

    it 'should give later properties precedence' do
      @stylesheet.query(:example_button)[:frame].should == [[100, 100], [200, 200]]
    end
  end

  describe 'when a stylename extends another' do
    before do
      @stylesheet = Teacup::Stylesheet.new do
        style :label,
          backgroundColor: :blue,
          font: "IMPACT"

        style :left_label, extends: :label,
          backgroundColor: :green,
          left: 100,
          width: 100

        style :how_much, extends: :left_label,
          backgroundColor: :red,
          top: 200,
          height: 200
      end

    end

    it 'should put extended properties into an "extends" Hash' do
      @stylesheet.query(:left_label)[:extends][:font].should == "IMPACT"
      @stylesheet.query(:left_label)[:left].should == 100
    end

    it 'should given the raw properties precedence' do
      @stylesheet.query(:left_label)[:backgroundColor].should == :green
    end

    it 'should follow a chain of extends' do
      @stylesheet.query(:how_much)[:backgroundColor].should == :red
      @stylesheet.query(:how_much)[:extends][:backgroundColor].should == :green
      @stylesheet.query(:how_much)[:extends][:extends][:backgroundColor].should == :blue
      @stylesheet.query(:how_much)[:extends][:left] == 100
      @stylesheet.query(:how_much)[:extends][:extends][:font] == "IMPACT"
    end
  end

  describe 'importing another stylesheet' do

    before do
      @oo_name_importer = Teacup::Stylesheet.new do
        import :importedbyname

        style :label,
          backgroundColor: :blue
      end

      Teacup::Stylesheet.new(:importedbyname) do
        style :label,
          title: "Imported by name"
      end

      @name_importer = Teacup::Stylesheet.new do
        import :importedbyname

        style :label,
          backgroundColor: :blue
      end

      # imported_anonymously = Teacup::Stylesheet.new do
      #   style :label,
      #     title: "Imported anonymously"
      # end

      # @anonymous_importer = Teacup::Stylesheet.new do
      #   import imported_anonymously
      #
      #   style :label,
      #     backgroundColor: :blue
      # end

      Teacup::Stylesheet.new(:importrecursion) do
        import :importrecursion

        style :label,
          importtitle: "Import recursion"
      end

      @broken_stylesheet = Teacup::Stylesheet.new do
        import :NonExtant

        style :label,
          backgroundColor: :blue
      end
    end

    after do
      Teacup::Stylesheet.stylesheets.delete(:importedbyname)
      Teacup::Stylesheet.stylesheets.delete(:importrecursion)
    end

    it 'should work with a name' do
      @name_importer.query(:label)[:title].should == "Imported by name"
      @name_importer.query(:label)[:backgroundColor].should == :blue
    end

    it 'should work with a name even if defined out of order' do
      @oo_name_importer.query(:label)[:title].should == "Imported by name"
      @oo_name_importer.query(:label)[:backgroundColor].should == :blue
    end

    # it 'should work with a value' do
    #   @anonymous_importer.query(:label)
    #   @anonymous_importer.query(:label)[:title].should == "Imported anonymously"
    #   @oo_name_importer.query(:label)[:backgroundColor].should == :blue
    # end

    it 'should not explode if a cycle is created' do
      Teacup::Stylesheet[:importrecursion].query(:label)[:importtitle].should == "Import recursion"
    end

    it 'should explode if an unknown stylesheet is imported' do
      error = nil
      begin
        @broken_stylesheet.query(:label)
      rescue Exception => error
      end
      error.nil?.should == false
    end
  end

  describe 'querying imported stylesheets' do
    before do
      @most_generic = Teacup::Stylesheet.new :most_generic do
        style :label,
          backgroundColor: :blue,
          title: "Most generic"

        style :button,
          title: "Click Here!"
      end

      @stylesheet = Teacup::Stylesheet.new :stylesheet do
        import :most_generic

        style :label,
          borderRadius: 10,
          title: "Stylesheet"
      end

      @most_specific = Teacup::Stylesheet.new :most_specific do
        import :stylesheet

        style :label,
          title: "Most specific",
          font: "IMPACT"
      end
    end

    it 'should union different properties for the same rule' do
      @stylesheet.query(:label)[:backgroundColor].should == :blue
      @stylesheet.query(:label)[:borderRadius] == 10
    end

    it 'should give the importer precedence' do
      @stylesheet.query(:label)[:title].should == "Stylesheet"
    end

    it 'should follow chains of imports' do
      @most_specific.query(:label)[:title].should == "Most specific"
      @most_specific.query(:label)[:font].should == "IMPACT"
      @most_specific.query(:label)[:borderRadius].should == 10
      @most_specific.query(:label)[:backgroundColor].should == :blue
    end

    it 'should allow querying a rule which exists only in the importee' do
      @stylesheet.query(:button)[:title].should == "Click Here!"
    end
  end

  describe 'precedence tree flattening' do
    it 'should give precedence to later imports' do
      stylesheet = Teacup::Stylesheet.new do
        import Teacup::Stylesheet.new{
          style :label_bla,
            text: "Imported first",
            backgroundColor: :blue
        }

        import Teacup::Stylesheet.new{
          style :label_bla,
            text: "Imported last"
        }
      end
      stylesheet.query(:label_bla)[:text].should == "Imported last"
      stylesheet.query(:label_bla)[:backgroundColor].should == :blue
    end

    it 'should give precedence to less-nested imports' do
      stylesheet = Teacup::Stylesheet.new do
        import Teacup::Stylesheet.new {
          import Teacup::Stylesheet.new {
            style :button,
              text: "Indirect import",
              backgroundColor: :blue
          }

          style :button,
            text: "Direct import"
        }
      end

      stylesheet.query(:button)[:text].should == "Direct import"
      stylesheet.query(:button)[:backgroundColor].should == :blue
    end

    it 'should give precedence to imported rules over extended rules' do
      stylesheet = Teacup::Stylesheet.new do
        style :textfield,
          text: "Extended",
          backgroundColor: :blue

        style :my_textfield, extends: :textfield,
          borderRadius: 10

        import Teacup::Stylesheet.new{
          style :my_textfield,
            text: "Imported"
        }
      end

      stylesheet.query(:my_textfield)[:text].should == "Imported"
      stylesheet.query(:my_textfield)[:extends][:backgroundColor].should == :blue
      stylesheet.query(:my_textfield)[:borderRadius].should == 10
    end
  end
end
