require "spec_helper"

describe PijQueriesController do
  describe "GET /index" do
    before :each do
      create :pij_query, :news, :expired
      create :pij_query, :evergreen, :expired
      create :pij_query, :utility
    end
    
    it "@evergreen only gets visible evergreen" do
      queries   = create_list :pij_query, 3, :evergreen, :visible
      create :pij_query, :news, :visible

      get :index
      evergreen = assigns(:evergreen)
      (evergreen & queries).should eq evergreen
    end
    
    it "@news only gets visible news" do
      queries = create_list :pij_query, 3, :news, :visible
      create :pij_query, :evergreen, :visible

      get :index
      news = assigns(:news)
      (news & queries).should eq news
    end
  end
  
  describe "GET /show" do
    it "assigns the query based on slug" do
      query = create :pij_query, :visible
      get :show, slug: query.slug
      assigns(:query).should eq query
    end
    
    it "raises 404 if the slug isn't found" do
      -> { 
        get :show, slug: "nonsense"
      }.should raise_error ActionController::RoutingError
    end
    
    it "raises 404 if pij query is not visible" do
      query = create :pij_query, :expired
      -> { 
        get :show, slug: query.slug
      }.should raise_error ActionController::RoutingError
    end
  end
end
