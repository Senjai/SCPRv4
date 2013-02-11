require File.expand_path("../../../spec_helper", __FILE__)

describe Outpost::List::Base do
  
  #--------------
  
  let(:admin) { Outpost::Admin.new(Outpost::Test::Person) }
  
  describe "initialize" do
    it "sets @columns to an empty array" do
      list = Outpost::List::Base.new(admin)
      list.instance_variable_get(:@columns).should eq []
    end
    
    it "sets order to anything passed in" do
      list = Outpost::List::Base.new(admin, order: "name desc")
      list.order.should eq "name desc"
    end
    
    it "sets order to default if nothing passed in" do
      list = Outpost::List::Base.new(admin)
      list.order.should eq Outpost::List::DEFAULTS[:order]
    end
    
    it "sets per_page to anything passed in" do
      list = Outpost::List::Base.new(admin, per_page: 16)
      list.per_page.should eq 16
    end
    
    it "sets per_page to default is nothing passed in" do
      list = Outpost::List::Base.new(admin)
      list.per_page.should eq Outpost::List::DEFAULTS[:per_page]
    end
  end
  
  #--------------

  describe "column" do
    let(:list)    { Outpost::List::Base.new(admin) }

    before :each do
      column = Outpost::List::Column.new("name", list, {})
      Outpost::List::Column.should_receive(:new).with("name", list, {}).and_return(column)
    end
    
    it "creates a new column object" do
      list.column("name")
    end
    
    it "adds that column to the list" do
      column = list.column("name")
      list.columns.should eq [column]
    end
    
    it "returns the column" do
      column = list.column("name")
      column.should be_a Outpost::List::Column
    end
  end
  
  #--------------
  
  describe "per_page=" do
    it "sets @per_page to nil if val is 'all'" do
      list = Outpost::List::Base.new(admin, per_page: :all)
      list.per_page.should be_nil
    end
    
    it "sets @per_page to default if none specified" do
      list = Outpost::List::Base.new(admin)
      list.per_page.should eq Outpost::List::DEFAULTS[:per_page]
    end
    
    it "sets @per_page to passed-in value as an integer if specified" do
      list = Outpost::List::Base.new(admin, per_page: "99")
      list.per_page.should eq 99
    end
  end
end
