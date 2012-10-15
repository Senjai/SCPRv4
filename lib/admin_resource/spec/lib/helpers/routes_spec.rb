require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Helpers::Routes do
  describe "::admin_new_path" do
    it "figures out the new path using singular_route_key" do
      Person.stub(:singular_route_key) { "coolguy" }
      Rails.application.routes.url_helpers.should_receive("new_admin_coolguy_path")
      Person.admin_new_path
    end
  end

  #---------------------
  
  describe "::admin_index_path" do
    it "figures out the index path using route_key" do
      Person.stub(:route_key) { "coolguys" }
      Rails.application.routes.url_helpers.should_receive("admin_coolguys_path")
      Person.admin_index_path
    end
  end

  #---------------------
  
  describe "#admin_edit_path" do
    it "figures out the edit path using singular_route_key and the record's id" do
      Person.stub(:singular_route_key) { "coolguy" }
      person = Person.new(name: "Cool Guy")
      Rails.application.routes.url_helpers.should_receive("edit_admin_coolguy_path").with(person.id)
      person.admin_edit_path
    end
  end

  #---------------------
  
  describe "#admin_show_path" do
    it "figures out the show path using singular_route_key and the record's id" do
      Person.stub(:singular_route_key) { "coolguy" }
      person = Person.new(name: "Cool Guy")
      Rails.application.routes.url_helpers.should_receive("admin_coolguy_path").with(person.id)
      person.admin_show_path
    end
  end
  
  #----------------
  
  describe "#link_path" do
    let(:person) { Person.new(name: "Bob Loblaw") }
    
    it "returns nil if #route_hash is blank" do
      person.stub(:route_hash) { Hash.new }
      person.link_path.should eq nil
    end
    
    it "returns nil if if ROUTE_KEY isn't defined" do
      class SomeClass; include AdminResource::Helpers::Routes; end
      something = SomeClass.new
      something.stub(:route_hash) { { id: 1, slug: "cool-dude" } }
      something.link_path.should eq nil
    end
    
    it "returns the route helper with the route hash" do
      Rails.application.routes.url_helpers.should_receive(:people_path).with(person.route_hash).and_return("blahblahblah")
      person.link_path.should eq "blahblahblah"      
    end
  end
  
  #----------------
  
  describe "#remote_link_path" do
    let(:person) { Person.create(name: "Dude Bro") }
    
    before :each do
      Rails.application.routes.url_helpers.should_receive(:people_path).with(person.route_hash).and_return("/people/#{person.id}/#{person.name.parameterize}")
    end
    
    it "contains the object's link path" do
      person.link_path.should_not be_blank
      person.remote_link_path.should match person.link_path
    end
    
    it "contains the configured remote URL" do
      Rails.application.config.scpr.stub(:host) { "www.foodnstuff.com" }
      person.remote_link_path.should match /http:\/\/www\.foodnstuff\.com/
    end
  end
  
  #----------------
  
  describe "#route_hash" do
    it "is just an empty hash, meant to be overridden" do
      class SomeClass; include AdminResource::Helpers::Routes; end
      SomeClass.new.route_hash.should eq Hash.new
    end
  end
end
