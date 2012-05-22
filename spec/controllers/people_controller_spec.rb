require "spec_helper"

describe PeopleController do
  describe "GET /index" do
    before :all do
      create_list :bio, 2, is_public: false
      create :bio, is_public: true, last_name: "Cacker"
      create :bio, is_public: true, last_name: "Acker"
      create :bio, is_public: true, last_name: "Backer"
    end
    
    before :each do
      get :index
    end
    
    it "responds with success" do
      response.should be_success
    end
    
    it "only shows public bios" do
      assigns(:bios).reject { |b| b.is_public == true }.should be_blank
    end
    
    it "orders by last name" do
      assigns(:bios).map(&:last_name).should eq ["Acker", "Backer", "Cacker"]
    end
  end
  
#  describe "GET /bio" do
#    before :all do
#      DatabaseCleaner.strategy = :truncation
#      ThinkingSphinx::Test.start
#    end
#    
#    before :each do
#      @bio = create :bio
#      puts "indexing..."
#      make_content(3)
#      ThinkingSphinx::Test.index
#    end
#    
#    after :all do
#      ThinkingSphinx::Test.stop      
#      DatabaseCleaner.strategy = :transation
#    end
#  
#    it "returns a Bio object" do
#      get :bio, name: @bio.slugged_name
#      assigns(:bio).should be_a Bio
#    end
#    
#    it "raises a routing error if the bio isn't found" do
#      get :bio, name: "badname"
#      response.should be_not_found
#    end
#  end
end