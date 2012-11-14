require File.expand_path("../../spec_helper", __FILE__)

describe AdminResource::Administrate do
  describe "administrate" do
    it "yields the block with the Admin object" do
      AdminResource::Test::Person.administrate do
        self.class.should == AdminResource::Admin
      end
    end
    
    it "creates an Admin object for the model" do
      AdminResource::Test::Person.administrate
      AdminResource::Test::Person.admin.should be_a AdminResource::Admin
    end
    
    it "uses columns in the define_list block if given" do
      AdminResource::Test::Person.should_not_receive(:set_default_columns)
      AdminResource::Test::Person.administrate do
        define_list do
          column :name
        end
      end
      AdminResource::Test::Person.admin.list.columns.map(&:attribute).should eq ["name"]
    end
    
    it "generates default columns if no define_list block is given" do
      AdminResource::Test::Person.administrate
      AdminResource::Test::Person.admin.list.columns.map(&:attribute).should include "name"
      AdminResource::Test::Person.admin.list.columns.map(&:attribute).should include "email"
    end
    
    it "generates default fields" do
      AdminResource::Test::Person.administrate
      AdminResource::Test::Person.admin.fields.should include "name"
      AdminResource::Test::Person.admin.fields.should include "email"
      AdminResource::Test::Person.admin.fields.should_not include "id"
      AdminResource::Test::Person.admin.fields.should_not include "updated_at"
      AdminResource::Test::Person.admin.fields.should_not include "created_at"
    end
  end
  
  describe "admin" do
    it "returns an Admin object" do
      AdminResource::Test::Person.admin.should be_a AdminResource::Admin
    end
    
    it "uses @admin if it already exists" do
      AdminResource::Test::Person.admin
      AdminResource::Admin.should_not_receive :new
      AdminResource::Test::Person.admin
    end
  end
end
