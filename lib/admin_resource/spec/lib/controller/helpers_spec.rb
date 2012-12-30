require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Controller::Helpers do
  describe "#resource_class" do
    let(:controller) { AdminResource::Test::PeopleController.new }
    
    it "sends off to Naming#to_class with the :controller param" do
      AdminResource::Helpers::Naming.should_receive(:to_class).with("admin/people")
      stub_const("Person", nil)
      controller.resource_class.should eq Person
    end
    
    it "adds resource_class as a helper" do
      controller._helper_methods.should include :resource_class
    end
  end
  
  #------------------------
  
  describe "#notice" do
    context "HTML request" do
      it "adds the notice to flash" do
        pending
      end
    end
    
    context "non-HTML request" do
      it "doesn't add anything to flash" do
        pending
      end
    end
  end
end
