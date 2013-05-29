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
  
  describe "as_json" do
    it "merges in extra attributes" do
      pending
      content_asset = build :asset
      extras = %w{caption ORDER credit}
      # (content_asset.as_json.keys & extras).should eq extras
    end
  end
end
