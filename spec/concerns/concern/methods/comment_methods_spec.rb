require "spec_helper"

describe Concern::Methods::CommentMethods do
  let(:story) { build :test_class_story }

  describe '::obj_by_disqus_identifier' do
    it 'finds and returns the object based on its disqus identifier' do
      story.save!
      Concern::Methods::CommentMethods.obj_by_disqus_identifier(story.disqus_identifier).should eq story
    end

    it 'is nil if nothing foond' do
      Concern::Methods::CommentMethods.obj_by_disqus_identifier("lol/nope:123").should be_nil
    end

    it 'can handle an irregular key' do
      Concern::Methods::CommentMethods.obj_by_disqus_identifier("lolwtfbbq").should be_nil
    end
  end

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
