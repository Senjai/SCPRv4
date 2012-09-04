require "admin_resource/spec_helper"

describe AdminResource::List::Column do
  describe "attributes" do
    subject { AdminResource::List::Column.new("name", 0) }
    
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
    let(:column) { 
      AdminResource::List::Column.new("name", 0, header: "Person", helper: :display_person, linked: true)
    }
    
    it "sets attribute" do
      column.attribute.should eq "name"
    end
  
    it "sets position" do
      column.position.should eq 0
    end
    
    it "sets header" do
      column.header.should eq "Person"
    end
    
    it "sets helper" do
      column.helper.should eq :display_person
    end
    
    it "sets linked" do
      column.linked.should eq true
    end
  end

  #----------------
  
  describe "linked?" do
    it "returns linked value" do
      column = AdminResource::List::Column.new("name", 0, linked: true)
      column.linked.should eq column.linked?
    end
  end
  
  #----------------
  
  describe "header" do
    it "returns the header if passed in" do
      column = AdminResource::List::Column.new("name", 0, header: "Person")
      column.header = "Person"
    end
    
    it "returns the titleized attribute if no header specified" do
      column = AdminResource::List::Column.new("name", 0)
      column.header.should eq "Name"
    end
  end
end
