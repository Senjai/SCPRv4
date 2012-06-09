require "spec_helper"

describe Admin::SessionsController do
  describe "GET /new" do
    it "returns success and renders new template if admin_user is false" do
      controller.stub(:admin_user) { false }
      get :new
      response.should be_success
      response.should render_template "new"
    end
    
    it "redirects to home page if admin_user if true" do
      controller.stub(:admin_user) { true }
      get :new
      response.should redirect_to admin_root_path
    end
  end
  
  describe "POST /create" do
    pending
  end
  
  describe "DELETE /destroy" do
    pending
  end
end
