require "spec_helper"

describe PeopleController do
  describe "GET /index" do    
    before :each do
      create_list :bio, 2, is_public: false
      create_list :bio, 2, is_public: true
      get :index
    end
    
    it "responds with success" do
      response.should be_success
    end
    
    it "only shows public bios" do
      assigns(:bios).reject { |b| b.is_public == true }.should be_blank
    end
    
    it "orders by last name" do
      assigns(:bios).to_sql.should match /order by last_name/i
    end
  end
  
  describe "GET /bio" do
    sphinx_spec(num: 1)
    let(:bio) { create :bio }
    
    it "returns a Bio object" do
      pending
      #get :bio, name: bio.slugged_name
      #assigns(:bio).should be_a Bio
    end
    
    it "redirects with flash message if the bio isn't found" do
      pending "Thinking Sphinx"
      #get :bio, name: "noname"
      #response.should be_redirect
      #flash[:alert].should be_present 
    end
  end
end