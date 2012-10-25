require "spec_helper"

describe Admin::SearchController do
  render_views
  
  describe "GET /index" do
    before :each do
      controller.stub(:admin_user) { create :admin_user }
    end
    
    it "figures out the class" do
      get :index, resource: "news_stories"
      assigns(:klass).should eq NewsStory
    end
    
    it "sends it off to ::search" do
      NewsStory.should_receive(:search).with("coolsearchbro", kind_of(Hash))
      get :index, resource: "news_stories", query: "coolsearchbro"
    end
  end
end
