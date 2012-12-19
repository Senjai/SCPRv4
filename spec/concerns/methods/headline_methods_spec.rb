require "spec_helper"

describe Concern::Methods::HeadlineMethods do
  subject { TestClass::Story.new }
  
  describe "#short_headline" do
    it "uses the stored short_headline if it's present" do
      subject.short_headline = "Short Headline"
      subject.short_headline.should eq "Short Headline"
    end
    
    it "uses the headline if short_headline isn't available" do
      subject.headline = "Headline"
      subject[:short_headline].should be_blank
      subject.short_headline.should eq "Headline"
    end
  end
end
