require "spec_helper"

describe ActiveModel::SecureAttribute do
  it "is invalid with blank passw on create" do
    user = build :admin_user, passw: ""
    user.should_not be_valid
  end

  it "nil passw" do
    user = build :admin_user, passw: nil
    user.should_not be_valid
  end

  it "blank passw doesn't override previous passw" do
    user = build :admin_user, passw: 'test'
    user.passw = ''
    user.passw.should eq 'test'
  end

 it "passw must be present" do
   user = build :admin_user, passw: ''
   user.should_not be_valid
   user.errors.keys.should eq [:passw]
 end

 it "match confirmation" do
   user = build :admin_user, passw: 'correct', passw_confirmation: "wrong"
   user.should_not be_valid
   user.errors.keys.should eq [:passw]

   user.passw_confirmation = "correct"
   user.should be_valid
 end

 it "authenticate" do
   user = create :admin_user, passw: "secret"
   user.authenticate("wrong").should be_false
   user.authenticate("secret").should eq user
 end

 it "#passw_digest should be protected against mass assignment" do
   pending
   #AdminUser.active_authorizers[:default].should be_a ActiveModel::MassAssignmentSecurity::BlackList
   #AdminUser.active_authorizers[:default].should include :passw_digest
 end

 it "mass_assignment_authorizer should be WhiteList" do
   pending
   #AdminUser.stub(:attr_accessible) { :name }
   #active_authorizer = AdminUser.active_authorizers[:default]
   #active_authorizer.should be_a ActiveModel::MassAssignmentSecurity::WhiteList
   #active_authorizer.should_not include :passw_digest
   #active_authorizer.should include :name
   #assert active_authorizer.include?(:name)
 end

 it "User should not be created with blank digest" do
   pending
   # user = build :admin_user, passw: ""
   # user.stub!(:passw_digest) { "" }
   # -> { user.save }.should raise_error
   # 
   # user.passw = "secret"
   # -> { user.save }.should_not raise_error
 end

 it "humanizes the column name for error" do
   pending
   # user = build :admin_user, passw: ""
   # 
   # begin
   #   AdminUser.create(user)
   # rescue RuntimeError => e
   #   e.message.should match "Encrypted passw missing on new record"
   # end
 end

 it "recogizes the column name passed in as an attribute" do
   build(:admin_user).methods.should include :passw_digest
 end

 it "recognizes the attribute name passed in as an attribute" do
   build(:admin_user).methods.should include :passw
 end

 it "adds column name passed in to attributes_protected_by_default" do
   pending
   # AdminUser.send(:attributes_protected_by_default).should include "passw_digest"
 end
end