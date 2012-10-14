require "spec_helper"

describe PijQueriesController do
  render_views
  
  describe "GET /index" do
    before :each do
      create :pij_query, :news, :expired
      create :pij_query, :evergreen, :expired
      create :pij_query, :utility
    end
    
    it "@evergreen only gets non-featured visible evergreen" do
      queries = create_list :pij_query, 3, :evergreen, :visible
      create :pij_query, :news, :visible
      create :pij_query, :evergreen, :featured, :visible

      get :index
      evergreen = assigns(:evergreen)
      (evergreen & queries).should eq evergreen
    end
    
    it "@news only gets non-featured visible news" do
      queries = create_list :pij_query, 3, :news, :visible
      create :pij_query, :evergreen, :visible
      create :pij_query, :news, :featured, :visible

      get :index
      news = assigns(:news)
      (news & queries).should eq news
    end
    
    it "@featured only gets featured queries" do
      queries = create_list :pij_query, 3, :featured
      create :pij_query, :evergreen, :unpublished
      create :pij_query, :news, :visible
      
      get :index
      featured = assigns(:featured)
      (featured & queries).should eq featured
    end
  end
  
  #-----------------
  
  describe "GET /show" do
    it "assigns the query based on slug" do
      query = create :pij_query, :visible
      get :show, slug: query.slug
      assigns(:query).should eq query
    end
    
    it "raises RecordNotFound if the slug isn't found" do
      -> { 
        get :show, slug: "nonsense"
      }.should raise_error ActiveRecord::RecordNotFound
    end
    
    it "raises RecordNotFound if pij query is not visible" do
      query = create :pij_query, :expired
      -> { 
        get :show, slug: query.slug
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end
end
