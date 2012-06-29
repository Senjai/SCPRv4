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
    
    it { should validate_confirmation_of(:unencrypted_password) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    
    it "should not care about case in the e-mail uniqueness validation" do
      other_user = build :admin_user, email: @user.email.upcase
      other_user.should_not be_valid
      other_user.errors[:email].should include "has already been taken"
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
      user = build :admin_user, first_name: "Bryan", last_name: "Cameron Ricker"
      user.send(:generate_username).should eq "bcricker"
    end
    
    it "removes non-word characters" do
      user = build :admin_user, name: "Adolfo Guzman-Lopez"
      user.send(:generate_username).should_not match /\W/
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
  
  describe "generate_password" do
    it "does not run if unencrypted_password is passed in" do
      user = build :admin_user, unencrypted_password: "hello"
      user.should_not_receive(:generate_password)
      user.save!
    end
    
    it "runs before validation on create" do
      user = build :admin_user, unencrypted_password: nil, unencrypted_password_confirmation: nil
      user.unencrypted_password.should be_nil
      user.save!
      user.unencrypted_password.should be_present
    end
    
    it "sets unencrypted_password and confirmation to a string" do
      user = create :admin_user, unencrypted_password: nil, unencrypted_password_confirmation: nil
      user.unencrypted_password.should be_a String
      user.unencrypted_password_confirmation.should eq user.unencrypted_password
    end
  end
  
  describe "digest_password" do
    it "runs before creation" do
      user = build :admin_user, password: nil
      user.password.should be_nil
      user.save!
      user.password.should be_present
    end
    
    it "generates a string that Mercer can understand" do
      user = create :admin_user, unencrypted_password: "secret"
      algorithm, salt, hash = user.password.split("$")
      algorithm.should eq "sha1"
      salt.should be_present
      hash.should be_present
    end
  end
end
