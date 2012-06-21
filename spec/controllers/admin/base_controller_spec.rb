require "spec_helper"

describe Admin::BaseController do
  describe "admin_user" do
    it "returns @admin_user if it exists" do
      controller.instance_variable_set(:@admin_user, "admin user")
      controller.session['_auth_user_id'] = true
      controller.admin_user.should eq "admin user"
    end
    
    it "looks up the ID stored in the session" do
      admin_user = create :admin_user
      controller.session['_auth_user_id'] = admin_user.id
      controller.admin_user.should eq admin_user
    end
    
    it "returns false if session is blank" do
      controller.session['_auth_user_id'] = nil
      controller.admin_user.should eq false
    end
    
    it "unsets the session and returns false if the user isn't found" do
      controller.session['_auth_user_id'] = 999
      controller.admin_user.should be_false
      controller.session['_auth_user_id'].should be_nil
    end
  end
  
  describe "require_admin" do
    controller { def index; end }
    
    describe "admin_user true" do
      it "returns true" do
        controller.stub(:admin_user) { true }
        controller.require_admin.should eq true
      end
    end
    
    describe "admin_user false" do
      before :each do
        controller.stub(:admin_user) { false }
        controller.request.stub(:fullpath) { "/home" }
        get :index
      end
      
      it "sets the return_to to the request path" do
        controller.session[:return_to].should eq "/home"
      end
    
      it "redirects to login path if admin_user is false" do
        controller.response.should redirect_to admin_login_path
      end
    end
  end
  
  describe "breadcrumb" do
    it "pushes the arguments, grouped in pairs as a hash, into @breadcrumbs" do
      controller.breadcrumb("Home", "/home", "New")
      controller.breadcrumbs.should eq [{title: "Home", link: "/home"}, {title: "New", link: nil}]
    end
    
    it "appends to @breadcrumbs if the variable already exists" do
      controller.instance_variable_set(:@breadcrumbs, [{title: "Home", link: "/home"}])
      controller.breadcrumb("New", nil, "Blogs", "/blogs")
      controller.breadcrumbs.should eq [{title: "Home", link: "/home"}, {title: "New", link: nil}, {title: "Blogs", link: "/blogs"}]
    end
  end
  
  describe "breadcrumbs" do
    it "returns @breadcrumbs" do
      controller.instance_variable_set(:@breadcrumbs, true)
      controller.breadcrumbs.should eq true
    end
  end
end