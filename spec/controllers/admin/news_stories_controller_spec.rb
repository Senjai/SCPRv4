require "spec_helper"

describe Admin::NewsStoriesController do
  before :each do
    @admin_user = create :admin_user
    controller.stub(:admin_user) { @admin_user }
  end
  
  let(:news_story) { create :news_story }
    
  describe "GET /index" do
    it "responds with success" do
      get :index
      response.should be_success
    end
    
    it "assigns @records" do
      get :index
      assigns(:records).should_not be_nil
    end
  end
  
  describe "GET /show" do
    it "responds with success" do
      get :show, id: news_story.id
      response.should be_success
    end
    
    it "assigns @record using the params ID" do
      get :show, id: news_story.id
      assigns(:record).should eq news_story
    end
  end
  
  describe "GET /new" do
    it "responds with success" do
      get :new
      response.should be_success
    end
    
    it "assigns @record to a new NewsStory object" do
      get :new
      record = assigns(:record)
      record.new_record?.should be_true
      record.should be_a NewsStory
    end
  end
  
  describe "GET /edit" do
    it "responds with success" do
      get :edit, id: news_story.id
      response.should be_success
    end
    
    it "assigns @record using the params" do
      get :edit, id: news_story.id
      assigns(:record).should eq news_story
    end
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
end