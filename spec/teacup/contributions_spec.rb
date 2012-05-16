require 'spec_helper'

describe "Teacup::CONTRIBUTORS" do

  it 'has contributors' do
    Teacup::CONTRIBUTORS.should be
  end

  it 'is an array' do
    Teacup::CONTRIBUTORS.should be_instance_of Array
  end

end
