require "spec_helper"

describe Concern::Validations::ContentValidation do
  subject { TestClass::Story.new }
  
  context "should validate" do
    before :each do
      subject.stub(:should_validate?) { true }
    end
    
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:headline) }
    it { should validate_presence_of(:body).with_message(Concern::Validations::ContentValidation::BODY_MESSAGE) }
    it { should validate_presence_of :short_headline }
    it { should validate_presence_of :teaser }
  end
  
  context "should not validate" do
    before :each do
      subject.stub(:should_validate?) { false }
    end
    
    it { should validate_presence_of :status }
    it { should validate_presence_of :headline }
    it { should_not validate_presence_of :body }
    it { should_not validate_presence_of :short_headline }
    it { should_not validate_presence_of :teaser }
  end
end
