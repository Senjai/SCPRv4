require "spec_helper"

describe CategoryController do
  describe "GET /index" do
    it "responds with success" do
      pending "Not getting the page properly"
      category = create :category_news
      get :index, id: category.id
      response.should be_success
    end
    
    it "raises a routing error if the page is not an integer" do
      pending "Not getting the page properly"
      category = create :category_news
      Scprv4::Application.reload_routes!
      #lambda { get :index, id: category.id, page: "about-town" }.should raise_error
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
