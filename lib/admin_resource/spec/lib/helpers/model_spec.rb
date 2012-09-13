require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Helpers::Model do
  describe "#to_title" do
    it "uses one of the specified title attributes if available" do
      stub_const("AdminResource::Helpers::Model::TITLE_ATTRIBUTES", [:name])
      person = Person.new(name: "Bryan Ricker")
      person.to_title.should eq "Bryan Ricker"
    end
    
    it "falls back to a simple_title if none of the attributes match" do
      stub_const("AdminResource::Helpers::Model::TITLE_ATTRIBUTES", [:title])
      person = Person.new(id: 1, name: "Bryan Ricker")
      person.should_receive(:simple_title).and_return("Simple Title")
      person.to_title.should eq "Simple Title"
    end
  end
  
  #----------------
  
  describe "#simple_title" do
    it "returns a simple name for a new object" do
      person = Person.new(id: 1, name: "Bryan Ricker")
      person.new_record?.should be_true
      person.simple_title.should eq "New Person"
    end
    
    it "returns a simple name for a persisted object" do
      person = Person.create(name: "Bryan Ricker")
      person.id.should be_present
      person.new_record?.should be_false
      person.simple_title.should eq "Person ##{person.id}"
    end
  end
  
  #----------------
  
  describe "::route_key" do
    it "uses ActiveModel's route_key method" do
      ActiveModel::Naming.should_receive(:route_key)
      Person.route_key
    end
  end
  
  #----------------
  
  describe "::singular_route_key" do
    it "uses ActiveModel's singular_route_key method" do
      ActiveModel::Naming.should_receive(:singular_route_key)
      Person.singular_route_key
    end
  end
end
