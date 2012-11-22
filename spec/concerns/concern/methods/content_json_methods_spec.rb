require "spec_helper"

describe Concern::Methods::ContentJsonMethods do
  describe "#json" do
    subject { TestClass::Story.new }
    it "merges in some extra attributes" do
      subject.json.keys.should include :asset
      subject.json.keys.should include :byline
    end
  end
end
