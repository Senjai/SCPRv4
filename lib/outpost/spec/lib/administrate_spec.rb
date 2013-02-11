require File.expand_path("../../spec_helper", __FILE__)

describe Outpost::Administrate do
  describe "administrate" do
    it "yields the block with the Admin object" do
      Outpost::Test::Person.administrate do
        self.class.should == Outpost::Admin
      end
    end
    
    it "creates an Admin object for the model" do
      Outpost::Test::Person.administrate
      Outpost::Test::Person.admin.should be_a Outpost::Admin
    end
    
    it "uses columns in the define_list block if given" do
      Outpost::Test::Person.should_not_receive(:set_default_columns)
      Outpost::Test::Person.administrate do
        define_list do
          column :name
        end
      end
      Outpost::Test::Person.admin.list.columns.map(&:attribute).should eq ["name"]
    end
    
    it "generates default columns if no define_list block is given" do
      Outpost::Test::Person.administrate
      Outpost::Test::Person.admin.list.columns.map(&:attribute).should include "name"
      Outpost::Test::Person.admin.list.columns.map(&:attribute).should include "email"
    end
    
    it "generates default fields" do
      Outpost::Test::Person.administrate
      Outpost::Test::Person.admin.fields.should include "name"
      Outpost::Test::Person.admin.fields.should include "email"
      Outpost::Test::Person.admin.fields.should_not include "id"
      Outpost::Test::Person.admin.fields.should_not include "updated_at"
      Outpost::Test::Person.admin.fields.should_not include "created_at"
    end
  end
  
  describe "admin" do
    it "returns an Admin object" do
      Outpost::Test::Person.admin.should be_a Outpost::Admin
    end
    
    it "uses @admin if it already exists" do
      Outpost::Test::Person.admin
      Outpost::Admin.should_not_receive :new
      Outpost::Test::Person.admin
    end
  end
end
