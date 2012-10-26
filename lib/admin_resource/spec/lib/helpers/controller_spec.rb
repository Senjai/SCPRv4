require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Helpers::Controller do
  let(:controller) { AdminResource::Test::PeopleController.new }

  #---------------
  
  describe "to_class" do
    it "turns the controller param into its corresponding class" do
      controller.to_class(controller.params[:controller]).should eq Person
    end
  end
end
