require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::List::Column do
  let(:admin) { AdminResource::Admin.new(AdminResource::Test::Person) }

  describe "attributes" do
    let(:list) { AdminResource::List::Base.new(admin) }
    subject { AdminResource::List::Column.new("name", list) }
  end

  #----------------
  
  describe "initialization" do
    let(:list) { AdminResource::List::Base.new(admin) }
    
    let(:column) {
      AdminResource::List::Column.new("name", list, quick_edit: true, display: :display_full_name, header: "Full Name")
    }
    
    before :each do
      list.column "name"
    end
    
    it "sets attribute" do
      column.attribute.should eq "name"
    end
    
    it "sets position" do
      list.column "body"
      list.columns[0].position.should eq 0
      list.columns[1].position.should eq 1
    end
    
    it "sets header" do
      column.header.should eq "Full Name"
    end
    
    it "sets display" do
      column.display.should eq :display_full_name
    end
    
    it "sets quick_edit" do
      column.quick_edit.should eq true
    end
  end

  #----------------
  
  describe "#header" do
    let(:list) { AdminResource::List::Base.new(admin) }
    
    it "returns the header if passed in" do
      column = AdminResource::List::Column.new("name", list, header: "Person")
      column.header = "Person"
    end
    
    it "returns the titleized attribute if no header specified" do
      column = AdminResource::List::Column.new("name", list)
      column.header.should eq "Name"
    end
  end
  
  #----------------
  
  describe "#quick_edit?" do
    let(:list) { AdminResource::List::Base.new(admin) }
    
    it "is the same as #quick_edit" do
      column = AdminResource::List::Column.new("name", list, quick_edit: true)
      column.quick_edit.should eq true
      column.quick_edit?.should eq true
    end
  end
end
