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
    pending
  end
  
  #----------------
  
  describe "#remote_link_path" do
    pending
  end
  
  #----------------
  
  describe "#route_hash" do
    it "is just an empty hash, meant to be overridden" do
      Person.new.route_hash.should eq Hash.new
    end
  end
end
