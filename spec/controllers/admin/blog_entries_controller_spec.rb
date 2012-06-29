require "spec_helper"

describe Admin::BlogEntriesController do
  before :each do
    @admin_user = create :admin_user
    controller.stub(:admin_user) { @admin_user }
  end
  
  let(:blog_entry) { create :blog_entry }
  
  describe "GET /index" do
    it "responds with success" do
      get :index
      response.should be_success
    end
  end
  
  describe "GET /show" do
    it "responds with success" do
      get :show, id: blog_entry.id
      response.should be_success
    end
  end
  
  describe "GET /new" do
    it "responds with success" do
      get :new
      response.should be_success
    end
  end
  
  describe "GET /edit" do
    it "responds with success" do
      get :edit, id: blog_entry.id
      response.should be_success
    end
  end
  
  describe "POST /create" do
    pending
  end
  
  describe "PUT /update" do
    pending
  end
  
  describe "DELETE /destroy" do
    pending
  end
end