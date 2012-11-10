require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Helpers::Controller do
  let(:controller) { AdminResource::Test::PeopleController.new }
  let(:news_story) { create :news_story }
  #---------------
  
  describe "#location" do
    it "returns edit path when requested" do
      news_story = create :news_story
      controller.stub(:params) { { commit_action: "edoit" } }
      controller.instance_variable_set :@record, news_story
      controller.location.should eq news_story.admin_edit_path
    end
    
    it "returns new path when requested" do
      controller.stub(:params) { { commit_action: "new" } }
      controller.instance_variable_set :@record, news_story
      controller.location.should eq news_story.class.admin_new_path
    end
    
    it "returns index path when requested" do
      controller.stub(:params) { { commit_action: "index" } }
      controller.instance_variable_set :@record, news_story
      controller.location.should eq admin_news_stories_path
    end
    
    it "returns index path by default" do      
      controller.location.should eq admin_news_stories_path
    end
  end  
end
