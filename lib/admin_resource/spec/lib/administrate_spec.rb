require File.expand_path("../../spec_helper", __FILE__)

describe AdminResource::Administrate do
  describe "administrate" do
    it "yields the block with the Admin object" do
      Person.administrate do
        self.class.should == AdminResource::Admin
      end
    end
    
    it "creates an Admin object for the model" do
      Person.administrate
      Person.admin.should be_a AdminResource::Admin
    end    
  end
  
  describe "admin" do
    it "returns an Admin object" do
      Person.admin.should be_a AdminResource::Admin
    end
    
    it "uses @admin if it already exists" do
      Person.admin
      AdminResource::Admin.should_not_receive :new
      Person.admin
    end
  end
end
