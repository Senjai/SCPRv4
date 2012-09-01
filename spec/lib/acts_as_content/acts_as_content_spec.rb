require "spec_helper"

# Until this is using its own testing data and models,
# NewsStory is being used to unit test ActsAsContent

describe ActsAsContent::InstanceMethods::HasFormat do
  let(:content) { create :news_story }
  
  describe "has_format?" do
    after :each do
      NewsStory.acts_as_content
    end
    
    it "returns false by default" do
      content.has_format?.should be_false
    end
    
    it "returns true if passed into the options" do
      NewsStory.acts_as_content has_format: true
      content.has_format?.should be_true
    end
    
    it "isn't defined if nil is passed" do
      pending "File needs to be reloaded somehow"
      NewsStory.acts_as_content has_format: nil
      content.should_not respond_to :has_format?
    end
  end
end

describe ActsAsContent::InstanceMethods::StatusHelpers do
  let(:content) { create :news_story }
  
  context "with has_status set to false" do
    after :each do
      NewsStory.acts_as_content
    end
    
    it "does not provide the status helpers" do
      pending "These tests need to be better"
      NewsStory.acts_as_content has_status: false
      NewsStory.new.should_not respond_to :killed?
    end
  end
  
  context "with has_status set to true" do
    after :each do
      NewsStory.acts_as_content
    end
    
    subject { content }
    it { should respond_to :killed? }
    it { should respond_to :draft? }
    it { should respond_to :awaiting_rework? }
    it { should respond_to :awaiting_edits? }
    it { should respond_to :pending? }
    it { should respond_to :published? }
  end
end

#--------------

describe ActsAsContent::InstanceMethods::AutoPublishedAt do
  let(:content) { create :news_story }
  
  after :each do
    NewsStory.acts_as_content
  end
  
  describe "auto_published_at" do
    it "returns true by default" do
      content.auto_published_at.should be_true
    end
    
    it "returns false if passed into the options" do
      NewsStory.acts_as_content auto_published_at: false
      content.auto_published_at.should be_false
    end
    
    it "isn't defined if nil is passed" do
      pending "File needs to be reloaded somehow"
      NewsStory.acts_as_content auto_published_at: nil
      content.should_not respond_to :auto_published_at
    end
  end
end

#--------------

describe ActsAsContent::InstanceMethods::Headline do
  let(:content) { create :news_story }
  
  after :each do
    NewsStory.acts_as_content
  end
  
  describe "headline" do
    it "uses headline if nothing passed in" do
      content.headline.should eq content[:headline]
    end
    
    it "uses whatever method is passed in" do
      pending "messes up later tests"
      NewsStory.acts_as_content headline: :short_headline
      content.headline.should eq content.short_headline
    end
  end
end

#--------------

describe ActsAsContent::InstanceMethods::Body do
  let(:content) { create :news_story }
  
  after :each do
    NewsStory.acts_as_content
  end
  
  describe "body" do
    it "uses body if nothing passed in" do
      content.body.should eq content[:body]
    end
    
    it "uses whatever method is passed in" do
      pending "messes up later tests"
      NewsStory.acts_as_content body: :teaser
      content.body.should eq content.teaser
    end
  end
end

#--------------

describe ActsAsContent::InstanceMethods::ObjKey do  
  describe "obj_key" do
    let(:content) { create :news_story }
    it "returns the CONTENT_TYPE and id joined" do
      content.obj_key.should eq "news/story:#{content.id}"
    end

    it "raises an error if CONTENT_TYPE isn't defined" do
      content_type = NewsStory::CONTENT_TYPE
      NewsStory.should_receive(:const_defined?).with(:CONTENT_TYPE).and_return(false)
      -> { content.obj_key }.should raise_error
    end
  end
end

#--------------

describe ActsAsContent::InstanceMethods::LinkPath do
  describe "remote_link_path" do
    let(:content) { create :news_story }
    it "returns a link to scpr.org" do
      content.remote_link_path.should match /scpr\.org/
    end
    
    it "has the link_path in the url" do
      content.remote_link_path.should match content.link_path
    end
  end
end
    
#--------------

describe ActsAsContent::InstanceMethods::Comments do
  let(:content) { create :news_story }
  
  describe "disqus_identifier" do
    it "raises an error if obj_key is not available" do
      content.should_receive(:respond_to?).with(:obj_key).and_return(false)
      -> { content.disqus_identifier }.should raise_error
    end
    
    it "returns the obj_key when it is defined" do
      content.disqus_identifier.should eq content.obj_key
    end
  end
  
  describe "disqus_shortname" do
    it "returns the globally defined disqus_shortname" do
      content.disqus_shortname.should eq API_KEYS["disqus"]["shortname"]
      content.disqus_shortname.should eq "kpcc"
    end
  end
end

#--------------

describe ActsAsContent::InstanceMethods::ShortHeadline do
  let(:content) { create :news_story }
  
  describe "short_headline" do
    it "returns self[:short_headline] if present" do
      content.short_headline.should eq content[:short_headline]
    end
    
    it "returns headline if not present" do
      content.update_attributes(short_headline: "")
      content.short_headline.should eq content.headline
    end
  end
end

#--------------

describe ActsAsContent::InstanceMethods::Teaser do  
  describe "teaser" do
    it "returns teaser if defined" do
      content = build :news_story, teaser: "This is a short teaser"
      content.teaser.should eq content[:teaser]
    end
    
    it "sends to generate_teaser if not defined" do
      content = build :news_story, teaser: nil
      ActsAsContent::Generators::Teaser.should_receive(:generate_teaser).with(content.body).and_return("Teaser")
      content.teaser.should eq "Teaser"
    end
  end
end

#--------------

describe ActsAsContent::Generators::Teaser do
  describe "generate_teaser" do
    it "returns empty string if text is blank" do
      ActsAsContent::Generators::Teaser.generate_teaser("").should eq ""
    end
    
    it "returns the full first paragraph if it's short enough" do
      first   = "This is just a short paragraph."
      body    = "#{first}\n And some more!"
      teaser  = ActsAsContent::Generators::Teaser.generate_teaser(body)
      teaser.should eq first
    end
    
    it "creates teaser from long paragraph if not defined" do
      long_body = load_response_fixture_file("long_text.txt")
      long_body.should match /\n/
      teaser = ActsAsContent::Generators::Teaser.generate_teaser(long_body)
      teaser.should match /^Lorem ipsum (.+)\.{3,}$/
      teaser.should_not match /\n/
    end
    
    it "uses the length passed in as a guideline for cutting off the text" do
      teaser1 = ActsAsContent::Generators::Teaser.generate_teaser("Testing a Teaser.", 1)
      teaser1.should eq "Testing..."
      
      teaser2 = ActsAsContent::Generators::Teaser.generate_teaser("Testing a Teaser.", 10)
      teaser2.should eq "Testing a Teaser..."      
    end
  end
end
