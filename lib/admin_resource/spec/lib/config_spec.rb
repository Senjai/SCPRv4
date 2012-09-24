require File.expand_path("../../spec_helper", __FILE__)

describe AdminResource::Config do
  describe "::configure" do
    it "generates a new Config object" do
      AdminResource::Config.should_receive(:new)
      AdminResource::Config.configure
    end
    
    it "accepts a block with the config object" do
      AdminResource::Config.configure do |config|
        config.should be_a AdminResource::Config
      end
    end
    
    it "sets AdminResource.config to the new Config object" do
      AdminResource::Config.configure
      AdminResource.config.should be_a AdminResource::Config
    end
  end
  
  describe "#registered_models" do
    it "returns an array if nothing is set" do
      AdminResource.config.registered_models = nil
      AdminResource.config.registered_models.should eq {}
    end
  end
  
  describe "#title_attributes" do
    it "returns the defaults plus :simple_title if nothing is set" do
      stub_const("AdminResource::Config::DEFAULTS", { title_attributes: [:title] })
      AdminResource.config.title_attributes = nil
      AdminResource.config.title_attributes.should eq [:title, :simple_title]
    end
    
    it "always includes simple_title" do
      stub_const("AdminResource::Config::DEFAULTS", { title_attributes: [] })
      AdminResource.config.title_attributes = nil
      AdminResource.config.title_attributes.should eq [:simple_title]
    end
  end
end
