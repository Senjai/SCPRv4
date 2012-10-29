require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::List::Column do
  describe "attributes" do
    let(:list) { AdminResource::List::Base.new }
    subject { AdminResource::List::Column.new("name", list) }
    
    it { should respond_to :attribute }
    it { should respond_to :attribute= }
    it { should respond_to :linked }
    it { should respond_to :linked= }
    it { should respond_to :linked? }
    it { should respond_to :header }
    it { should respond_to :header= }
    it { should respond_to :helper }
    it { should respond_to :helper= }
  end

  #----------------
  
  describe "initialization" do
    let(:list) {
      AdminResource::List::Base.new
    }
    
    let(:column) {
      AdminResource::List::Column.new("name", list, linked: true, display: :display_full_name, header: "Full Name")
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
    
    it "sets helper" do
      column.helper.should eq :display_full_name
    end
    
    it "sets linked" do
      column.linked.should eq true
    end
  end

  #----------------
  
  describe "linked?" do
    it "returns linked value" do
      list   = AdminResource::List::Base.new
      column = AdminResource::List::Column.new("name", list, linked: true)
      column.linked.should eq column.linked?
    end
  end
  
  #----------------
  
  describe "header" do
    let(:list) { AdminResource::List::Base.new }
    
    it "returns the header if passed in" do
      column = AdminResource::List::Column.new("name", list, header: "Person")
      column.header = "Person"
    end
    
    it "returns the titleized attribute if no header specified" do
      column = AdminResource::List::Column.new("name", list)
      column.header.should eq "Name"
    end
  end
end
