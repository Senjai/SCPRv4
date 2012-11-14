require "spec_helper"

describe Concern::Validations::PublishedAtValidation do
  subject { TestClass::RemoteStory.new }
  
  context "should validate" do
    before :each do
      subject.stub(:should_validate?) { true }
    end
    
    it { should validate_presence_of(:published_at) }
  end
  
  context "should not validate" do
    before :each do
      subject.stub(:should_validate?) { false }
    end
    
    it { should_not validate_presence_of(:published_at) }
  end
end
