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
      AdminResource.config.registered_models.should eq []
    end
  end
end
