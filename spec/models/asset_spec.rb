require "spec_helper"

describe Asset do
  describe "config" do
    it "is the assethost configuration" do
      Asset.config.should eq Rails.application.config.assethost
    end
  end
  
  #---------------------
  
  Asset.outputs.each do |output|
    subject { Asset.new(load_fixture("assethost_asset.json")) }
    it { should respond_to output['code'].to_sym }
  end

  #---------------------
  
  describe "outputs" do
    after :each do
      Asset.instance_variable_set :@outputs, nil
    end
    
    it "uses @outputs if it already exists" do
      Asset.instance_variable_set :@outputs, "Outputs"
      Asset.outputs.should eq "Outputs"
    end
    
    it "uses the cached version if it exists" do
      Rails.cache.read("assets/outputs").should be_nil
      Rails.cache.write("assets/outputs", "OUTPUTS!")
      Asset.outputs.should eq "OUTPUTS!"
    end
    
    it "sends a request to the api to get outputs" do
      outputs = Asset.outputs
      FakeWeb.last_request.path.should match "/outputs"
    end
    
    it "returns fallback outputs if the API can't be reached" do
      Faraday::Response.any_instance.stub(:status) { 500 }
      JSON.should_receive(:load).with(load_fixture("assethost_outputs.json")).and_return("Fallback Outputs")
      Asset.outputs.should eq "Fallback Outputs"
    end
    
    it "writes to cache on successful API response" do
      Rails.cache.should_receive(:write).with("assets/outputs", load_fixture("assethost_outputs.json"))
      Asset.outputs
    end
  end
  
  #---------------------
  
  describe "find" do
    it "returns cached asset json if it exists" do
      Rails.cache.read("asset/asset-1").should be_nil
      Asset.should_receive(:new).with("Asset #1").and_return("Okedoke")
      Rails.cache.write("asset/asset-1", "Asset #1")
      Asset.find(1).should eq "Okedoke"
    end
    
    it "sends a request to the API on cache miss" do
      asset = Asset.find(1)
      FakeWeb.last_request.path.should match "api/assets/1"
    end
    
    context "bad response" do
      before :each do
        Faraday::Response.any_instance.stub(:status) { 500 }
      end
      
      it "Returns a fallback asset" do
        Asset.find(1).should be_a Asset::Fallback
      end
  
      it "logs the fallback" do
        Asset::Fallback.should_receive(:log).with(500, 1)
        Asset.find(1)
      end
    end
    
    context "good response" do
      it "writes to cache" do
        Rails.cache.should_receive(:write).with("asset/asset-1", load_fixture("assethost_asset.json"))
        Asset.find(1)
      end
      
      it "creates a new asset from the json" do
        Asset.should_receive(:new).with(load_fixture("assethost_asset.json"))
        Asset.find(1)
      end
    end
  end
  
  #---------------------
end
