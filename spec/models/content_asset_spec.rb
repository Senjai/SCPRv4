require "spec_helper"

describe ContentAsset do
  it { should belong_to :content }
  
  describe "asset" do
    it "finds the asset and returns it" do
      content_asset = build :asset
      content_asset.asset.should be_a AssetHost::Asset
    end
    
    it "Adds in a fallback caption if asset is a Fallback" do
      content_asset = build :asset
      content_asset.stub(:asset) { AssetHost::Asset::Fallback.new }
      content_asset.asset.caption.should match "We encountered a problem"
    end
  end
end
