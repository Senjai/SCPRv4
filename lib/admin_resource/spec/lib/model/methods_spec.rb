require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Model::Methods do
  describe "::to_title" do
    it "returns the titleized class name" do
      AdminResource::Test::Person.to_title.should eq "Person"
      AdminResource::Test::Person.stub(:name) { "SomeModule::Person" }
      AdminResource::Test::Person.to_title.should eq "Person"
      AdminResource::Test::Person.stub(:name) { "SomeModule::PersonThing"}
      AdminResource::Test::Person.to_title.should eq "Person Thing"
    end
  end

  #----------------
  
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
  
  describe "#as_json" do
    pending
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
  
  #----------------
  
  describe "#persisted_record" do
    pending
  end
  
  #----------------
  
  describe "#to_title" do
    it "uses one of the specified title attributes if available" do
      AdminResource.config.title_attributes = [:name]
      person = AdminResource::Test::Person.create(name: "Bryan Ricker")
      person.to_title.should eq "Bryan Ricker"
    end

    # This is actually being handled by config.title_attributes being injected
    # with :simple_title... we can test it here anyways
    it "falls back to a simple_title if none of the attributes match" do
      AdminResource.config.title_attributes = [:title]
      person = AdminResource::Test::Person.create(id: 1, name: "Bryan Ricker")
      person.should_receive(:simple_title).and_return("Simple Title")
      person.to_title.should eq "Simple Title"
    end
  end
  
  #----------------
  
  describe "#simple_title" do
    it "returns a simple name for a new object" do
      person = AdminResource::Test::Person.new(id: 1, name: "Bryan Ricker")
      person.new_record?.should be_true
      person.simple_title.should eq "New Person"
    end
    
    it "returns a simple name for a persisted object" do
      person = AdminResource::Test::Person.create(name: "Bryan Ricker")
      person.id.should be_present
      person.new_record?.should be_false
      person.simple_title.should eq "Person ##{person.id}"
    end
  end
end
