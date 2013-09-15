require "spec_helper"

describe Concern::Methods::CommentMethods do
  subject { build :test_class_story }

  describe "#disqus_identifier" do
    it "returns the identifier" do
      subject.save!
      subject.disqus_identifier.should eq "test/class/stories:#{subject.id}"
    end
  end

  #--------------------
  
  describe "#disqus_shortname" do
    it "returns the globally defined disqus_shortname" do
      Rails.application.config.stub(:api) { { "disqus" => { "shortname" => "blahblah" } } }
      subject.disqus_shortname.should eq "blahblah"
    end
  end
end
