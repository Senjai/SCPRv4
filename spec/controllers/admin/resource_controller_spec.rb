require "spec_helper"

describe Admin::ResourceController do
  describe "get_record" do
    it "returns the record if it exists" do
      record = create :news_story
      controller.stub!(:params).and_return({ id: record.id })
      controller.stub!(:resource_class) { NewsStory }
      
      controller.get_record.should eq record
    end
    
    it "raises a RoutingError if ID does not exist" do
      controller.stub!(:params) { { id: "000" } }
      controller.stub!(:resource_class) { NewsStory }
      -> { controller.get_record }.should raise_error ActionController::RoutingError
    end
  end
  
  describe "get_records" do
    pending
  end
  
  describe "respond" do
    pending
  end
  
  describe "respond_with_resource" do
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
  
  describe "resource_class" do
    pending
  end
  
  describe "resource_title" do
    pending
  end
  
  describe "resource_param" do
    pending
  end
  
  describe "resource_path_helper" do
    pending
  end
  
  describe "extend_breadcrumbs_with_resource_route" do
    pending
  end
end