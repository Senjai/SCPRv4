require "spec_helper"

describe Concern::Methods::CommentMethods do
  subject { TestClass::Story.new }
  
  describe "#disqus_identifier" do
    it "returns the obj_key" do
      subject.stub(:obj_key) { "story:999" }
      subject.disqus_identifier.should eq "story:999"
    end
  end

  #--------------------
  
  describe "#disqus_shortname" do
    it "returns the globally defined disqus_shortname" do
      stub_const("API_CONFIG", { "disqus" => { "shortname" => "blahblah" } })
      subject.disqus_shortname.should eq "blahblah"
    end
  end
end
