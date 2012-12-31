require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Model::Identifier do
  describe "::content_key" do
    it "uses the table name if it responds to it" do
      AdminResource::Test::Person.stub(:table_name) { "people_and_stuff" }
      AdminResource::Test::Person.content_key.should eq "people/and/stuff"
    end
    
    it "tableizes the classname if no table" do
      AdminResource::Test::Person.content_key.should eq "people"
    end
  end
  
  #----------------
    
  describe "::route_key" do
    it "uses ActiveModel's route_key method" do
      ActiveModel::Naming.should_receive(:route_key)
      AdminResource::Test::Person.route_key
    end
  end
  
  #----------------
  
  describe "::singular_route_key" do
    it "uses ActiveModel's singular_route_key method" do
      ActiveModel::Naming.should_receive(:singular_route_key)
      AdminResource::Test::Person.singular_route_key
    end
  end
  
  #----------------
  
  describe "#obj_key" do
    context "for persisted record" do
      it "uses the class's content_key, the record's ID, and joins by :" do
        person = AdminResource::Test::Person.create(name: "Bryan")
        person.id.should_not be_blank
        person.obj_key.should eq "people:#{person.id}"
      end
    end
    
    context "for new record" do
      it "uses new in the key" do
        person = AdminResource::Test::Person.new(name: "Bryan")
        person.obj_key.should eq "people:new"
      end
    end
  end
end
