require "spec_helper"

describe Dashboard::Api::ContentController do
  before :each do
    controller.stub(:require_admin) { create :admin_user }
  end

  #--------------
  
  describe "GET /index" do
    let(:contents) { make_content(1) }
    
    it "gets all the objects by key and returns them as json" do
      get :index, ids: [contents.first.obj_key, contents.last.obj_key]
      response.body.should eq [contents.first, contents.last].to_json
      response.header['Content-Type'].should match /json/
    end
    
    it "doesn't include nil elements" do
      get :index, ids: [contents.first.obj_key, "nope/bad:9999"]
      JSON.parse(response.body).size.should eq 1
    end
  end
  
  #--------------
  
  describe "GET /show" do
    context "content is found" do
      let(:content) { create :blog_entry }
      
      it "returns the content as json" do
        get :show, id: content.obj_key
        response.should be_success
        response.body.should eq content.to_json
        response.header['Content-Type'].should match /json/
      end
    end
    
    context "content isn't found" do
      it "returns 404" do
        get :show, id: "nothing/nope:123"
        response.should be_not_found
      end
    end
  end
  
  #--------------
  
  describe "POST /preview" do    
    context "content is found" do
      let(:content) { create :blog_entry }
      
      it "finds the object with obj_by_key" do
        post :preview, id: content.obj_key
        assigns(:content).should eq content
      end
      
      it "sets the content't attributes to the params" do
        headline = "The preview headline"
        post :preview, id: content.obj_key, headline: headline
        assigns(:content).headline.should eq headline
      end
      
      it "renders the js template" do
        post :preview, id: content.obj_key
        response.should be_success
        response.should render_template "preview"
        response.header['Content-Type'].should match /javascript/
      end
    end
    
    context "content isn't found" do
      it "returns 404" do
        post :preview, id: "nope/nothing:123"
        response.should be_not_found
      end
    end
  end
  
  #--------------
  
  describe "GET /by_url" do
    context "content is found" do
      let(:content) { create :blog_entry }
      
      it "returns the content as json" do
        get :by_url, id: content.remote_link_path
        response.should be_success
        response.body.should eq content.to_json
        response.header['Content-Type'].should match /json/
      end
    end
    
    context "content isn't found" do
      it "returns 404" do
        get :by_url, id: "http://nope.com/nothing"
        response.should be_not_found
      end
    end
  end
  
  #--------------
  
  describe "GET /recent" do
    context "cache hit" do
      let(:content) { create :blog_entry }
      let(:cache)   { content.to_json.to_s }
      
      before :each do
        Rails.cache.should_receive(:fetch).with("cbaseapi:recent").and_return(cache)
      end
      
      it "returns the cache as json" do
        get :recent
        response.body.should eq cache
        response.header['Content-Type'].should match /json/
      end
    end
    
    context "cache miss" do
      sphinx_spec(num: 2)
      
      before :each do
        Rails.cache.should_receive(:fetch).with("cbaseapi:recent").and_return(nil)
      end
      
      it "returns the sphinx results as json" do
        get :recent
        response.body.should match @generated_content.first.to_json
        response.body.should match @generated_content.last.to_json
        response.header['Content-Type'].should match /json/
      end
      
      it "writes the json to the cache" do
        Rails.cache.should_receive(:write_entry)
        get :recent
      end
    end
  end
end
