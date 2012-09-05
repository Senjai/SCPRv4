require "admin_resource/spec_helper"

describe AdminResource::List::Base do
  describe "attributes" do
    it { should respond_to :order }
    it { should respond_to :order= }
    it { should respond_to :per_page }
    it { should respond_to :per_page= }
    it { should respond_to :columns }
  end
  
  #--------------
  
  describe "initialize" do
    it "sets @columns to an empty array" do
      list = AdminResource::List::Base.new
      list.instance_variable_get(:@columns).should eq []
    end
    
    it "sets order to anything passed in" do
      list = AdminResource::List::Base.new(order: "name desc")
      list.order.should eq "name desc"
    end
    
    it "sets order to default if nothing passed in" do
      list = AdminResource::List::Base.new
      list.order.should eq AdminResource::List::DEFAULTS[:order]
    end
    
    it "sets per_page to anything passed in" do
      list = AdminResource::List::Base.new(per_page: 16)
      list.per_page.should eq 16
    end
    
    it "sets per_page to default is nothing passed in" do
      list = AdminResource::List::Base.new
      list.per_page.should eq AdminResource::List::DEFAULTS[:per_page]
    end
  end

  #--------------
  
  describe "linked_columns" do
    it "returns @linked_columns if set" do
      list   = AdminResource::List::Base.new
      list.instance_variable_set(:@linked_columns, "hello")
      list.linked_columns.should eq "hello"
    end
    
    it "select columns in that list which are linked" do
      list    = AdminResource::List::Base.new
      linked  = list.column("name", linked: true)
      unlined = list.column("body", linked: false)
      list.linked_columns.should eq [linked]
    end
  end
  
  #--------------

  describe "column" do
    pending
  end
  
  #--------------
  
  describe "per_page" do
    pending
  end
end
