require File.expand_path("../../../spec_helper", __FILE__)

describe Outpost::Controller::Helpers do
  describe "#model" do
    let(:controller) { Outpost::Test::PeopleController.new }
    
    it "sends off to Naming#to_class with the :controller param" do
      Outpost::Helpers::Naming.should_receive(:to_class).with("admin/people")
      stub_const("Person", nil)
      controller.model.should eq Person
    end
    
    it "adds model as a helper" do
      controller._helper_methods.should include :model
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
