require "spec_helper"

describe Admin::NewsStoriesController do
  describe "GET /index" do
    it "paginates @news_stories" do
      get :index
      #assigns(:news_stories).count.should eq 25
    end
    
    it "" do
    end
  end
end