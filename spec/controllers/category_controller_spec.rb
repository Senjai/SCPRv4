require "spec_helper"

describe CategoryController do
  describe "GET /index" do
    it "assigns @category" do
      category = create :category_news
      get :index, category: category.slug
      assigns(:category).should eq category
    end
  end
  
#   describe "GET /news" do
#     before :all do
#       puts "Starting Sphinx and indexing..."
#       DatabaseCleaner.strategy = :truncation
#       make_content(7)
#       categories = create_list :category_news, 2
#       ThinkingSphinx::Test.start
#       ThinkingSphinx::Test.index
#     end
#     
#     after :all do
#       ThinkingSphinx::Test.stop
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
#       puts "Starting Sphinx and indexing..."
#       DatabaseCleaner.strategy = :truncation
#       categories = create_list :category_not_news, 2
#       make_content(7)
#       ThinkingSphinx::Test.start
#       ThinkingSphinx::Test.index
#     end
#     
#     after :all do
#       ThinkingSphinx::Test.stop
#       DatabaseCleaner.strategy = :transaction
#     end
#     
#     it "responds with success" do
#       get :arts
#       response.should be_success
#     end
#   end
end
