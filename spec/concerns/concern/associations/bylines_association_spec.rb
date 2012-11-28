require "spec_helper"

describe Concern::Associations::BylinesAssociation do
  describe "associations" do
    subject { TestClass::Story.new }
    it { should have_many(:bylines).class_name("ContentByline").dependent(:destroy) }
  end
  
  #--------------------
  
  describe "#byline_elements" do
    it "is an array" do
      TestClass::Story.new.byline_elements.should be_a Array
    end
  end
end
