require "spec_helper"

describe Admin::BaseController do
  describe "#requested_location" do
    it "returns edit path when requested" do
      news_story = create :news_story
      controller.requested_location("edit", news_story).should eq edit_admin_news_story_path(news_story)
    end
    
    it "returns new path when requested" do
      controller.requested_location("new", double(class: NewsStory)).should eq new_admin_news_story_path
    end
    
    it "returns index path when requested" do
      controller.requested_location("index", double(class: NewsStory)).should eq admin_news_stories_path
    end
    
    it "returns index path by default" do
      controller.requested_location("nonsense", double(class: NewsStory)).should eq admin_news_stories_path
    end
    
    it "raises an error if record is blank" do
      lambda { controller.requested_location("nonsense", nil) }.should raise_error ArgumentError 
    end
  end
end