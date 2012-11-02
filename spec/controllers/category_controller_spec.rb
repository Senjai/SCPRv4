require "spec_helper"

describe CategoryController do
  render_views
  
  describe "GET /index" do    
    it "assigns @category" do
      category = create :category_news
      
      get :index, category: category.slug
      assigns(:category).should eq category
    end
    
    describe "with XML" do
      it "renders xml template when requested" do
        category = create :category_news
        
        get :index, category: category.slug, format: :xml
        response.should render_template 'category/index'
        response.header['Content-Type'].should match /xml/
      end
    end
  end
  
  describe "respond_by_format" do
    pending
  end
  
  describe "get_content_from" do
    pending
  end
  
  describe "generate_sections_for" do
    pending
  end
  
   describe "GET /news" do
     pending
   end
   
   describe "GET /arts" do
     pending
   end
end
