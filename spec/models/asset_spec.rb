require "spec_helper"

describe AssetHost::Asset do
  describe "config" do
    it "is the assethost configuration" do
      AssetHost::Asset.config.should eq Rails.application.config.assethost
    end
  end
  
  #---------------------
  
  describe "outputs" do
    before :each do
      AssetHost::Asset.instance_variable_set :@outputs, nil
      Rails.cache.clear
    end
    
    after :all do
      AssetHost::Asset.instance_variable_set :@outputs, nil
      Rails.cache.clear
    end
    
    it "uses @outputs if it already exists" do
      AssetHost::Asset.instance_variable_set :@outputs, "Outputs"
      AssetHost::Asset.outputs.should eq "Outputs"
    end
    
    it "uses the cached version if it exists" do
      Rails.cache.read("assets/outputs").should be_nil
      Rails.cache.write("assets/outputs", "OUTPUTS!")
      AssetHost::Asset.outputs.should eq "OUTPUTS!"
    end
    
    it "sends a request to the api to get outputs" do
      outputs = AssetHost::Asset.outputs
      FakeWeb.last_request.path.should match "/outputs"
    end
    
    it "returns fallback outputs if the API can't be reached" do
      Faraday::Response.any_instance.stub(:status) { 500 }
      JSON.should_receive(:load).with(File.read(Rails.root.join("util/fixtures/assethost_outputs.json"))).and_return({ some: "outputs" })
      AssetHost::Asset.outputs.should eq({ some: "outputs" })
    end
    
    it "writes to cache on successful API response" do
      Rails.cache.should_receive(:write).with("assets/outputs", anything)
      AssetHost::Asset.outputs
    end
  end
  
  #---------------------
  
  describe "find" do
    it "returns cached asset json if it exists" do
      Rails.cache.read("asset/asset-1").should be_nil
      AssetHost::Asset.should_receive(:new).with("AssetHost::Asset #1").and_return("Okedoke")
      Rails.cache.write("asset/asset-1", "AssetHost::Asset #1")
      AssetHost::Asset.find(1).should eq "Okedoke"
    end
    
    it "sends a request to the API on cache miss" do
      asset = AssetHost::Asset.find(1)
      FakeWeb.last_request.path.should match "api/assets/1"
    end
    
    context "bad response 500" do
      before :each do
        Faraday::Response.any_instance.stub(:status) { 500 }
      end
      
      it "Returns a fallback asset" do
        AssetHost::Asset.find(1).should be_a AssetHost::Asset::Fallback
      end
  
      it "logs the fallback" do
        AssetHost::Asset::Fallback.should_receive(:log).with(500, 1)
        AssetHost::Asset.find(1)
      end
    end
    
    context "bad response 502" do
      before :each do
        Faraday::Response.any_instance.stub(:status) { 502 }
      end
      
      it "Returns a fallback asset" do
        AssetHost::Asset.find(1).should be_a AssetHost::Asset::Fallback
      end
  
      it "logs the fallback" do
        AssetHost::Asset::Fallback.should_receive(:log).with(502, 1)
        AssetHost::Asset.find(1)
      end
    end
    
    context "good response" do
      it "writes to cache" do
        Rails.cache.should_receive(:write).with("asset/asset-1", JSON.load(load_fixture("assethost_asset.json")))
        AssetHost::Asset.find(1)
      end
      
      it "creates a new asset from the json" do
        AssetHost::Asset.should_receive(:new).with(JSON.load(load_fixture("assethost_asset.json")))
        AssetHost::Asset.find(1)
      end
    end
  end
  
  #-------------------
  
  it "generates AssetHost::Asset Sizes for each output" do
    asset = AssetHost::Asset.find(1) # stubbed response
    asset.thumb.should be_a AssetHost::AssetSize
    asset.lsquare.should be_a AssetHost::AssetSize
  end
end

#---------------------------

describe AssetHost::AssetSize do
  it "provides access to the asset attributes" do
    output = AssetHost::Asset.outputs.first
    asset  = AssetHost::Asset.find(1)
    size   = AssetHost::AssetSize.new(asset, output)

    size.width.should be_present
    size.height.should be_present
    size.tag.should be_present
    size.url.should be_present
  end
end

#---------------------------

describe AssetHost::Asset::Fallback do
  it "loads the fallback json" do
    JSON.should_receive(:load).with(Rails.root.join("util/fixtures/assethost_fallback.json")).and_return({ some: "json" })
    AssetHost::Asset::Fallback.new.json.should eq({ some: "json" })
  end
  
  it "loads fallback json as a hash" do
    AssetHost::Asset::Fallback.new.json.should be_a Hash
  end
  
  it "is an asset" do
    AssetHost::Asset::Fallback.new.should be_a AssetHost::Asset
  end
end

