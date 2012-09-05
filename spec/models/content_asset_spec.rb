require "spec_helper"

describe ContentAsset do
  it { should belong_to :content }
  
  describe "asset" do
    it "returns @_asset if assigned" do
      content_asset = build :asset
      content_asset.instance_variable_set(:@_asset, "some asset")
      content_asset.asset.should eq "some asset"
    end
    
    it "finds the asset if @_asset not assigned" do
      content_asset = build :asset
      content_asset.asset.should be_a Asset # JSON response
    end
    
    it "Adds in a fallback caption if @_asset is a Fallback" do
      content_asset = build :asset
      content_asset.stub(:asset) { Asset::Fallback.new }
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
    
  it "assigns django_content_type_id before it is created" do
    asset = build :asset
    asset.django_content_type_id.should be_nil
    asset.save
    asset.django_content_type_id.should be_a Fixnum
  end
end
