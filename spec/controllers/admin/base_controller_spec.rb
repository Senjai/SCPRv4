require "spec_helper"

describe Admin::BaseController do
  describe "admin_user" do
    pending
  end
  
  describe "require_admin" do
    pending
  end
  
  describe "respond" do
    pending
  end
  
  describe "respond_with_resource" do
    pending
  end
  
  describe "get_record" do
    pending
  end
  
  describe "get_records" do
    pending
  end
  
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
    
    it "returns nil if action is blank" do
      controller.requested_location(nil, double(class: NewsStory)).should be_nil
    end
  end
  
  describe "breadcrumb" do
    pending
  end
end