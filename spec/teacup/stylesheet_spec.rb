require 'spec_helper'

describe "Teacup::Stylesheet" do

  describe 'creation' do
    before do
      @stylesheet = Teacup::Stylesheet.new(:ConstantTest) { }
    end

    after do
      Teacup::Stylesheet.send(:remove_const, :ConstantTest)
    end

    it 'should create constants for named stylesheets' do
      Teacup::Stylesheet::ConstantTest.should == @stylesheet
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
      @stylesheet.query(:example_button).should include(frame: [[0, 0], [100, 100]])
    end

    it 'should let you define properties for many stylenames' do
      @stylesheet.query(:example_label).should include(backgroundColor: :blue)
      @stylesheet.query(:example_textfield).should include(backgroundColor: :blue)
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
      @stylesheet.query(:example_button).should include(title: "Example!", backgroundColor: :blue)
    end

    it 'should give later properties precedence' do
      @stylesheet.query(:example_button).should include(frame: [[100, 100], [200, 200]])
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

    it 'should union different properties' do
      @stylesheet.query(:left_label).should include(font: "IMPACT", left: 100)
    end

    it 'should given the raw properties precedence' do
      @stylesheet.query(:left_label).should include(backgroundColor: :green)
    end

    it 'should follow a chain of extends' do
      @stylesheet.query(:how_much).should include(backgroundColor: :red, left: 100, font: "IMPACT")
    end
  end

  describe 'importing another stylsheet' do

    before do
      @oo_name_importer = Teacup::Stylesheet.new do
        import :ImportedByName

        style :label,
          backgroundColor: :blue
      end

      Teacup::Stylesheet.new(:ImportedByName) do
        style :label,
          title: "Imported by name"
      end

      @name_importer = Teacup::Stylesheet.new do
        import :ImportedByName

        style :label,
          backgroundColor: :blue
      end
      
      imported_anonymously = Teacup::Stylesheet.new do
        style :label,
          title: "Imported anonymously"
      end

      @anonymous_importer = Teacup::Stylesheet.new do
        import imported_anonymously

        style :label,
          backgroundColor: :blue
      end

      Teacup::Stylesheet.new(:ImportRecursion) do
        import :ImportRecursion

        style :label,
          title: "Import recursion"
      end

      @broken_stylesheet = Teacup::Stylesheet.new do
        import :NonExtant

        style :label,
          backgroundColor: :blue
      end
    end

    after do
      Teacup::Stylesheet.send(:remove_const, :ImportedByName)
      Teacup::Stylesheet.send(:remove_const, :ImportRecursion)
    end

    it 'should work with a name' do
      @name_importer.query(:label).should include(title: "Imported by name", backgroundColor: :blue)
    end

    it 'should work with a name even if defined out of order' do
      @oo_name_importer.query(:label).should include(title: "Imported by name", backgroundColor: :blue)
    end

    it 'should work with a value' do
      @anonymous_importer.query(:label).should include(title: "Imported anonymously", backgroundColor: :blue)
    end

    it 'should not explode if a cycle is created' do
      Teacup::Stylesheet::ImportRecursion.query(:label).should include(title: "Import recursion")
    end

    it 'should explode if an unknown stylesheet is imported' do
      lambda {
        @broken_stylesheet.query(:label)
      }.should raise_error(/Stylesheet::NonExtant/)
    end
  end

  describe 'querying imported stylesheets' do
    before do
      most_generic = Teacup::Stylesheet.new do
        style :label,
          backgroundColor: :blue,
          title: "Most generic"

        style :button,
          title: "Click Here!"
      end

      stylesheet = Teacup::Stylesheet.new do
        import most_generic

        style :label,
          borderRadius: 10,
          title: "Stylesheet"
      end

      most_specific = Teacup::Stylesheet.new do
        import stylesheet

        style :label,
          title: "Most specific",
          font: "IMPACT"
      end

      @most_specific, @stylesheet = [most_specific, stylesheet]
    end

    it 'should union different properties for the same rule' do
      @stylesheet.query(:label).should include(backgroundColor: :blue, borderRadius: 10)
    end

    it 'should give the importer precedence' do
      @stylesheet.query(:label).should include(title: "Stylesheet")
    end

    it 'should follow chains of imports' do
      @most_specific.query(:label).should include(title: "Most specific", font: "IMPACT", borderRadius: 10, backgroundColor: :blue)
    end

    it 'should allow querying a rule which exists only in the importee' do
      @stylesheet.query(:button).should include(title: "Click Here!")
    end
  end

  describe 'precedence tree flattening' do
    it 'should give precedence to later imports' do
      stylesheet = Teacup::Stylesheet.new do
        import Teacup::Stylesheet.new{
          style :label,
            text: "Imported first",
            backgroundColor: :blue
        }

        import Teacup::Stylesheet.new{
          style :label,
            text: "Imported last"
        }
      end
      stylesheet.query(:label).should include(text: "Imported last", backgroundColor: :blue)
    end

    it 'should give precedence to less-nested imports' do
      stylesheet = Teacup::Stylesheet.new do
        import Teacup::Stylesheet.new{
          import Teacup::Stylesheet.new{
            style :button,
              text: "Indirect import",
              backgroundColor: :blue
          }

          style :button,
            text: "Direct import"
        }
      end
      stylesheet.query(:button).should include(text: "Direct import", backgroundColor: :blue)
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
      stylesheet.query(:my_textfield).should include(text: "Imported", backgroundColor: :blue, borderRadius: 10)
    end
  end
end
