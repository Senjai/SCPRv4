require "spec_helper"

describe AdminUser do
  describe "active" do
    it "only returns active users" do
      inactive = create :admin_user, is_active: false
      active = create :admin_user, is_active: true
      #AdminUser.active.all.should eq [active]
    end
  end
  
  describe "validations" do
    before(:each) { @user = create :admin_user, name: "Ryan Bicker" }
    
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    
    it "should not care about case in the e-mail uniqueness validation" do
      other_user = build :admin_user, email: @user.email.upcase
      other_user.should_not be_valid
      other_user.errors[:email].should include "has already been taken"
    end
  end
  
  describe "callbacks" do
    it "generates an auth_token on user creation" do
      user = build :admin_user
      user.auth_token.should be_blank
      user.save
      user.auth_token.should be_present
    end
  end
  
  describe "downcase_email" do
    it "downcases the e-mail before validating and saving a user" do
      user = create :admin_user, email: "SomeEmail@email.com"
      user.email.should eq "someemail@email.com"
    end
  end
  
  describe "generate_token" do
    pending
  end
  
  describe "generate_username" do
    it "runs before create" do
      user = build :admin_user
      user.username.should be_nil
      user.save!
      user.username.should be_present
    end
    
    it "does not run on update" do
      user = create :admin_user, name: "Bryan Ricker"
      first_uname = user.username
      user.name = "Leslie Knope"
      user.save!
      user.username.should eq first_uname
    end
    
    it "splits the name and return an approximation of first names letters + last-name" do
      user = build :admin_user, name: "Bryan Cameron Ricker"
      user.generate_username.should eq "bcricker"
    end
    
    it "removes non-word characters" do
      user = build :admin_user, name: "Adolfo Guzman-Lopez"
      user.generate_username.should_not match /\W/
    end
    
    it "appends and increments an integer if username already exists" do
      user = create :admin_user, name: "Bryan Ricker"
      user2 = create :admin_user, name: "Blake Ricker"
      user3 = create :admin_user, name: "Bob Ricker"
      user.username.should_not match /\d/
      user2.username.should match "1"
      user3.username.should match "2"
    end
    
    it "allows a username to be passed in at creation" do
      user = create :admin_user, name: "Bryan Ricker", username: "darthvader"
      user.username.should eq "darthvader"
    end
  end
    
  describe "generate_password" do
    it "generates a password on user creation" do
      pending "Removed this method temporarily"
      user = create :admin_user
      user.passw_digest.should be_present
    end
    
    it "generates a different password every time" do
      pending
    end
    
    it "does not generate a password when the user is updated" do
      pending "Removed this method temporarily"
      password = "qxqxqx" # generator will never generate this password
      user = create :admin_user, passw: password
      user.update_attributes(name: "Leslie Knope")
      AdminUser.authenticate(user.email, password).should eq user
    end
  end
  
  describe "authenticate" do
    it "returns false if the username does not exist" do
      user = create :admin_user, passw: "secret", name: "Bryan Ricker"
      AdminUser.authenticate("nobody", "secret").should be_false
    end
    
    it "hands it off to authenticate_legacy" do
      pending "not stubbing correctly, need to fix"
      user = create :admin_user, passw: "secret"
      user.stub(:authenticate_legacy) { "authenticate_legacy" }
      AdminUser.authenticate(user.username, user.passw).should eq "authenticate_legacy"
    end
  end
  
  describe "authenticate_legacy" do 
    it "returns the user if the password is correct" do
      user = build :admin_user, passw: "secret"
      user.authenticate_legacy(user.passw).should eq user
    end
    
    it "generates passw_digest if the password is correct" do
      user = build :admin_user, passw: "secret"
      user.authenticate_legacy(user.passw)
      user.passw_digest.should be_present
    end
    
    it "returns false if the password is incorrect" do
      user = build :admin_user, passw: "secret"
      user.authenticate_legacy("wrong").should be_false
    end
    
    it "generates an auth_token if the password is correct" do
      user = build :admin_user, passw: "secret"
      user.auth_token.should be_blank
      user.authenticate_legacy(user.passw)
      user.auth_token.should be_present
    end
  end
end
