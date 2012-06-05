require "spec_helper"

describe AdminUser do
  describe "active" do
    pending
  end
  
  describe "validations" do
    before(:each) { @user = create :admin_user, name: "Ryan Bicker" }
    
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:email).case_insensitive }
    
    it "should not care about case in the e-mail uniqueness validation" do
      other_user = build :admin_user, email: @user.email.upcase
      other_user.should_not be_valid
      other_user.errors[:email].should include "has already been taken"
    end
  end
  
  describe "callbacks" do
    it "downcases the e-mail before validating and saving a user" do
      user = create :admin_user, email: "SomeEmail@email.com"
      user.email.should eq "someemail@email.com"
    end
    
    it "generates an auth_token on user creation" do
      user = build :admin_user
      user.auth_token.should be_blank
      user.save
      user.auth_token.should be_present
    end
  end
  
  describe "generate_username" do
    pending
  end
    
  describe "generate_password" do
    it "generates a password on user creation" do
      user = create :admin_user
      user.password_digest.should be_present
    end
    
    it "generates a different password every time" do
      pending
    end
    
    it "does not generate a password when the user is updated" do
      password = "qxqxqx" # generator will never generate this password
      user = create :admin_user, password: password
      user.update_attributes(name: "Leslie Knope")
      AdminUser.authenticate(user.email, password).should eq user
    end
  end
  
  describe "authenticate" do
    it "returns the user if the password is correct" do
      user = create :admin_user, password: "secret"
      AdminUser.authenticate(user.email, "secret").should eq user
    end
  
    it "returns false if the username does not exist" do
      user = create :admin_user, password: "secret", username: "bricker"
      AdminUser.authenticate("nobody", "secret").should be_false
    end
    
    it "returns false if the password is incorrect" do
      user = create :admin_user, password: "secret"
      AdminUser.authenticate(user.username, "incorrect").should be_false
    end
    
    it "hands it off to authenticate_legacy if password_digest is blank" do
      pending
    end
  end
  
  describe "authenticate_legacy" do 
    it "returns the user if the password is correct" do
      pending
    end
    
    it "generates password_digest if the password is correct" do
      pending
    end
    
    it "returns false if the password is incorrect" do
      pending
    end
    
    it "generates an auth_token if the password is correct" do
      pending
    end
  end
end
