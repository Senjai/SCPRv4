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
    
    it "uses columns in the define_list block if given" do
      Person.should_not_receive(:set_default_columns)
      Person.administrate do
        define_list do
          column :name
        end
      end
      Person.admin.list.columns.map(&:attribute).should eq ["name"]
    end
    
    it "generates default columns if no define_list block is given" do
      Person.administrate
      Person.admin.list.columns.map(&:attribute).should include "name"
      Person.admin.list.columns.map(&:attribute).should include "email"
    end
    
    it "generates default fields" do
      Person.administrate
      Person.admin.fields.should include "name"
      Person.admin.fields.should include "email"
      Person.admin.fields.should_not include "id"
      Person.admin.fields.should_not include "updated_at"
      Person.admin.fields.should_not include "created_at"
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
