require "spec_helper"

describe Concern::Methods::TeaserMethods do
  subject { TestClass::Story.new }
  
  describe "#teaser" do
    it "uses the stored teaser if it's present" do
      subject.teaser = "Teaser"
      subject.teaser.should eq "Teaser"
    end
    
    it "sends off to ContentBase#generate_teaser with #body if teaser is not present" do
      subject.body = "Body"
      subject[:teaser].should be_blank
      ContentBase.should_receive(:generate_teaser).with("Body").and_return "Cut down Body"
      subject.teaser.should eq "Cut down Body"
    end
  end
end
