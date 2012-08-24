require "spec_helper"

describe Promotion do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
    
    describe "asset" do
      it "returns false if asset_id is blank" do
        promotion = build :promotion, asset_id: nil
        promotion.asset.should be_false
      end
      
      it "returns an asset if asset_id is present" do
        promotion = build :promotion, asset_id: 99
        promotion.asset.should be_a Asset
      end
    end
  end
end
