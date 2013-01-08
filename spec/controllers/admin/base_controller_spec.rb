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
    
    it "only finds user where is_staff is true" do
      staff_user = create :admin_user, is_staff: true
      controller.session['_auth_user_id'] = staff_user.id
      controller.admin_user.should eq staff_user
      
      controller.instance_variable_set(:@admin_user, nil)
      nostaff_user = create :admin_user, is_staff: false
      controller.session['_auth_user_id'] = nostaff_user.id
      controller.admin_user.should eq nil
    end
    
    it "returns false if session is blank" do
      controller.session['_auth_user_id'] = nil
      controller.admin_user.should eq nil
    end
    
    it "unsets the session and returns false if the user isn't found" do
      controller.session['_auth_user_id'] = 999
      controller.admin_user.should eq nil
      controller.session['_auth_user_id'].should eq nil
      controller.instance_variable_get(:@admin_user).should eq nil
    end
  end
  
  #-----------------
  
  describe "require_admin" do
    controller do
      before_filter :require_admin
      
      def index
        render nothing: true
      end
    end
    
    context "admin_user true" do
      it "returns nil" do
        user = create :admin_user
        controller.stub(:admin_user) { user }
        controller.require_admin.should eq nil
      end
    end
    
    context "admin_user false" do
      before :each do
        controller.stub(:admin_user) { nil }
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
  
  #-----------------
  
  describe "#authorize!" do
    pending
  end
end
