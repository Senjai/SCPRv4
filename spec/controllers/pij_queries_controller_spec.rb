require "spec_helper"

describe PijQueriesController do
  render_views
  
  describe "GET /index" do
    before :each do
      create :pij_query, :draft, query_type: "news"
      create :pij_query, :draft, query_type: "evergreen"
      create :pij_query, query_type: "utility"
    end
    
    it "@evergreen only gets non-featured visible evergreen" do
      queries = create_list :pij_query, 3, :published, query_type: "evergreen"
      create :pij_query, :published, query_type: "news"
      create :pij_query, :published, :featured, query_type: "evergreen"

      get :index
      evergreen = assigns(:evergreen)
      (evergreen & queries).should eq evergreen
    end
    
    it "@news only gets non-featured visible news" do
      queries = create_list :pij_query, 3, :published, query_type: "news"
      create :pij_query, :published, query_type: "evergreen"
      create :pij_query, :published, :featured, query_type: "news"

      get :index
      news = assigns(:news)
      (news & queries).should eq news
    end
    
    it "@featured only gets featured queries" do
      queries = create_list :pij_query, 3, :featured
      create :pij_query, :draft, query_type: "evergreen"
      create :pij_query, :published, query_type: "news"
      
      get :index
      featured = assigns(:featured)
      (featured & queries).should eq featured
    end
  end
  
  #-----------------
  
  describe "GET /show" do
    it "assigns the query based on slug" do
      query = create :pij_query, :published
      get :show, slug: query.slug
      assigns(:query).should eq query
    end
    
    it "raises RecordNotFound if the slug isn't found" do
      -> { 
        get :show, slug: "nonsense"
      }.should raise_error ActiveRecord::RecordNotFound
    end
    
    it "raises RecordNotFound if pij query is not visible" do
      query = create :pij_query, :draft
      -> { 
        get :show, slug: query.slug
      }.should raise_error ActiveRecord::RecordNotFound
    end
  end
end
