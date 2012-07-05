require "spec_helper"

describe CategoryController do
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
        response.should render_template 'category/index', format: :xml
      end
    end
  end
  
#   describe "GET /news" do
#     before :all do
#       DatabaseCleaner.strategy = :truncation
#       make_content(7)
#       categories = create_list :category_news, 2
#       ThinkingSphinx::Test.index
#     end
#     
#     after :all do
#       DatabaseCleaner.strategy = :transaction
#     end
#     
#     it "responds with success" do
#       get :news
#       response.should be_success
#     end
#   end
#   
#   describe "GET /arts" do
#     before :all do
#       DatabaseCleaner.strategy = :truncation
#       make_content(7)
#       categories = create_list :category_not_news, 2
#       ThinkingSphinx::Test.index
#     end
#     
#     after :all do
#       DatabaseCleaner.strategy = :transaction
#     end
#     
#     it "responds with success" do
#       get :arts
#       response.should be_success
#     end
#   end
end
