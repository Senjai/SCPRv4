require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Helpers::Controller do
  let(:controller) { PeopleController.new }
  
  describe "singular_resource" do
    it "turns the passed-in controller param into what a param or instance var should be" do
      controller.singular_resource(controller.params[:controller]).should eq "person"
    end
  end
  
  #---------------
  
  describe "to_class" do
    it "turns the controller param into its corresponding class" do
      controller.to_class(controller.params[:controller]).should eq Person
    end
  end

  #---------------
  
  describe "to_title" do
    it "turns the controller param into a human-readable title" do
      controller.to_title(controller.params[:controller]).should eq "Person"
    end
  end

  #---------------
  
  describe "extract_controller" do
    it "extracts the controller from a full path" do
      # Important Note: This method is kind of stupid
      controller.extract_controller("/r/admin/people/edit/99").should eq "admin/people"
    end
  end
end
