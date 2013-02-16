require "spec_helper"

describe AdminUser do
  describe "associations" do
    it { should have_many(:activities).class_name("Secretary::Version") }
    it { should have_one(:bio) }
    it { should have_many(:admin_user_permissions) }
    it { should have_many(:permissions).through(:admin_user_permissions) }
  end
  
  #------------------------
  
  describe "scopes" do
    describe "active" do
      it "only returns active users" do
        inactive = create :admin_user, is_active: false
        active   = create :admin_user, is_active: true
        AdminUser.active.should eq [active]
      end
    end
  end
  
  #------------------------
  
  describe "#can_manage?" do
    let(:permission1) { Permission.find_by_resource("NewsStory") }
    let(:permission2) { Permission.find_by_resource("BlogEntry") }

    context "superuser" do
      let(:superuser) { create :admin_user, is_superuser: true }
      
      it "is true for superusers" do
        superuser.can_manage?("anything").should eq true
      end
    end
    
    context "non-superuser" do
      let(:user) { create :admin_user, is_superuser: false }
      
      it "is true if the user can manage all of the passed-in resources" do
        user.permissions += [permission1, permission2]
        user.can_manage?(NewsStory, BlogEntry).should eq true
      end
    
      it "is false if the user can manage only some of the passed-in resources" do
        user.permissions += [permission1]
        user.can_manage?(NewsStory, BlogEntry).should eq false
      end
    end
  end
  
  #------------------------
  
  describe "downcase_email" do
    it "downcases the e-mail before validating and saving a user" do
      user = create :admin_user, email: "SomeEmail@email.com"
      user.email.should eq "someemail@email.com"
    end
  end

  #------------------------
  
  describe "authenticate" do 
    it "returns the user if the username and password are correct" do
      user = create :admin_user, unencrypted_password: "secret"
      AdminUser.authenticate(user.username, user.unencrypted_password).should eq user
    end
    
    it "returns false if the password is incorrect" do
      user = create :admin_user, unencrypted_password: "secret"
      AdminUser.authenticate(user.username, "wrong").should be_false
    end
    
    it "returns false if the username isn't found" do
      user = create :admin_user, username: "bricker"
      AdminUser.authenticate("wrong", "secret")
    end
  end
end
