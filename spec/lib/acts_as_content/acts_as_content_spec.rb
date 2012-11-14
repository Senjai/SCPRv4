__END__
require "spec_helper"

# Until this is using its own testing data and models,
# NewsStory is being used to unit test ActsAsContent

describe ActsAsContent::Methods::Headline do
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

describe ActsAsContent::Methods::Body do
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

describe ActsAsContent::Methods::Comments do
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

describe ActsAsContent::Methods::ShortHeadline do
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

describe ActsAsContent::Methods::Teaser do  
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
