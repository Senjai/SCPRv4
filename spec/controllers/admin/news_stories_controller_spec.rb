require "spec_helper"

describe Admin::NewsStoriesController do
  before :each do
    @admin_user = create :admin_user
    controller.stub(:admin_user) { @admin_user }
  end
  
  describe "GET /index" do
    it "responds with success" do
      get :index
      response.should be_success
    end
    
    it "assigns @news_stories" do
      get :index
      assigns(:news_stories).should_not be_nil
    end
  end
  
  describe "GET /show" do
    it "responds with success" do
      news_story = create :news_story
      get :show, id: news_story.id
      response.should be_success
    end
    
    it "assigns @news_story using the params ID" do
      news_story = create :news_story
      get :show, id: news_story.id
      assigns(:news_story).should eq news_story
    end
  end
  
  describe "GET /new" do
    it "responds with success" do
      get :new
      response.should be_success
    end
    
    it "assigns @news_story to a new NewsStory object" do
      get :new
      assigns(:news_story).new_record?.should be_true
    end
  end
  
  describe "GET /edit" do
    it "responds with success" do
      news_story = create :news_story
      get :edit, id: news_story.id
      response.should be_success
    end
    
    it "assigns @news_story using the params" do
      news_story = create :news_story
      get :edit, id: news_story.id
      assigns(:news_story).should eq news_story
    end
  end
  
  describe "POST /create" do
    let(:news_story) { build :news_story }
    pending
  end
  
  describe "PUT /update" do
    pending
  end
  
  describe "DELETE /destroy" do
    pending
  end
  
  describe "get_record" do
    it "returns @news_story if it exists" do
      news_story = create :news_story
      get :show, id: news_story.id
      assigns(:news_story).should eq news_story
    end
    
    it "raises a RoutingError if ID does not exist" do
      -> { get :show, id: 000 }.should raise_error ActionController::RoutingError
    end
  end
end