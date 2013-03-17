require "spec_helper"

describe Concern::Validations::SlugValidation do
  subject { TestClass::RemoteStory.new }
  
  context "should validate" do
    before :each do
      subject.stub(:should_validate?) { true }
    end

    it { should validate_presence_of(:slug) }
    it { should allow_value("cool-slug").for(:slug) }
    it { should_not allow_value("invalid@characters.?").for(:slug).with_message(/Only letters/) }
    it { should ensure_length_of(:slug).is_at_most(50) }
  end
  
  context "should not validate" do
    before :each do
      subject.stub(:should_validate?) { false }
    end
    
    it { should_not validate_presence_of(:slug) }
    it { should allow_value("invalid@characters.?").for(:slug) }
    it { should_not ensure_length_of(:slug).is_at_most(50) }
  end
end
