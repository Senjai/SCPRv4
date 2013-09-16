require "spec_helper"

describe Concern::Methods::CommentMethods do
  let(:story) { build :test_class_story }


  describe "#disqus_identifier" do
    it "returns the identifier" do
      story.save!
      story.disqus_identifier.should eq "#{TestClass::Story.disqus_identifier_base}:#{story.id}"
    end
  end

  #--------------------
  
  describe "#disqus_shortname" do
    it "returns the globally defined disqus_shortname" do
      Rails.application.config.stub(:api) { { "disqus" => { "shortname" => "blahblah" } } }
      story.disqus_shortname.should eq "blahblah"
    end
  end
end
