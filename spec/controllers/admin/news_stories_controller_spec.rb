require "spec_helper"

describe Admin::NewsStoriesController do
  describe "GET /index" do
    it "assigns @news_stories" do
      get :index
      assigns(:news_stories).should_not be_nil
    end
  end
  
  describe "GET /show" do
    pending
  end
  
  describe "GET /new" do
    pending
  end
  
  describe "GET /edit" do
    pending
  end
  
  describe "POST /create" do
    pending
  end
  
  describe "PUT /update" do
    pending
  end
  
  describe "DELETE /destroy" do
    pending
  end
  
  describe "get_record" do
    pending
  end
end