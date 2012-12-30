require "spec_helper"

describe ContentByline do
  describe "associations" do
    it { should belong_to(:user).class_name("Bio") }
    it { should belong_to(:content) }
  
    it "assigns django_content_type_id before it is created" do
      byline = build :byline
      byline.django_content_type_id.should be_nil
      byline.save
      byline.django_content_type_id.should be_a Fixnum
    end
  end
  
  #-----------------------
  
  describe "::digest" do
    it "joins the three string arguments" do
      ContentByline.digest({ 
        primary: "one", 
        secondary: "two", 
        extra: "three"
      }).should eq "one with two | three"
    end
    
    it "ignores blank elements" do
      ContentByline.digest({ 
        primary: "", 
        secondary: "two", 
        extra: "three"
      }).should eq "two | three"
      
      ContentByline.digest({ 
        primary: "one", 
        secondary: "two", 
      }).should eq "one with two"
    end
    
    it "returns an empty string if no bylines are present" do
      ContentByline.digest({
        primary: "",
        secondary: "",
        extra: ""
      }).should eq ""
      
      ContentByline.digest({}).should eq ""
    end
  end
  
  #-----------------------
  
  describe "#display_name" do
    context "with a user" do
      it "returns the user's name" do
        user   = create :bio, name: "Bryan"
        byline = build :byline, user: user
        byline.display_name.should eq "Bryan"
      end
    end
    
    context "without a user" do
      it "returns the byline's name attribute" do
        byline = build :byline, name: "Ricker", user: nil
        byline.display_name.should eq "Ricker"
      end
    end
  end
end
