require "spec_helper"

describe Concern::Associations::AssetAssociation do
  subject { TestClass::Story.new }
  
  describe "association" do
    it { should have_many(:assets).class_name("ContentAsset").dependent(:destroy) }
  
    it "orders by asset_order" do
      subject.assets.to_sql.should match /order by asset_order/i
    end
  end
  
  #--------------------

  describe "#primary_asset" do
    it "is nil if content has no assets" do
      record = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
      record.reload.primary_asset(:thumb).should eq nil
    end
    
    it "returns the first asset with tag by default" do
      record = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
      asset  = create :asset, content: record
      record.reload.primary_asset(:thumb).should eq asset.asset.thumb.tag
    end
    
    it "returns the first asset with whatever format is passed in" do
      record = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
      asset  = create :asset, content: record
      record.reload.primary_asset(:lsquare, :url).should eq asset.asset.lsquare.url
    end
  end
  
  #--------------------
  
  describe "#parse_asset_json" do
    context "no asset_json passed in" do
      it "doesn't do anything" do
        newrecord = TestClass::Story.create!(asset_json: "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]", headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        newrecord.assets.size.should eq 1
        
        record = TestClass::Story.find(newrecord.id)
        record.should_not_receive(:make_assets)
        record.asset_json.should eq nil
        record.save!
        record.assets.size.should eq 1
      end
    end
    
    context "for new record" do
      it "parses the json and adds the asset on save" do
        record = TestClass::Story.new(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]"
        record.assets.size.should eq 0
        record.save!
        record.reload.assets.size.should eq 1
        record.assets.first.caption.should eq "Caption"
        record.assets.first.asset_order.should eq 12
      end
    end
    
    context "for persisted record with new asset" do
      it "parses the json and adds the asset on save" do
        record = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        record.assets.size.should eq 0
        record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]"
        record.save!
        record.reload.assets.size.should eq 1
        record.assets.first.caption.should eq "Caption"
        record.assets.first.asset_order.should eq 12
      end
    end
    
    context "for persisted record when updating asset" do
      it "parses the json and updates the asset on save" do
        record = TestClass::Story.create!(asset_json: "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]", headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        record.assets.size.should eq 1
        record.assets.first.caption.should eq "Caption"
        record.assets.first.asset_order.should eq 12
        
        record.asset_json = "[{\"id\":32459,\"caption\":\"New Caption\",\"asset_order\":5}]"
        record.save!
        record.reload.assets.size.should eq 1
        record.assets.first.caption.should eq "New Caption"
        record.assets.first.asset_order.should eq 5
      end
    end
    
    context "when removing assets" do
      it "destroys any assets that weren't in the passed-in asset_json" do
        record = TestClass::Story.create!(asset_json: "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":11},{\"id\":32458,\"caption\":\"Caption\",\"asset_order\":12}]", headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        record.assets.map(&:asset_id).should eq [32459, 32458]
        
        record.asset_json = "[{\"id\":32459,\"caption\":\"New Caption\",\"asset_order\":5}]"
        record.save!
        record.reload.assets.size.should eq 1
        record.assets.map(&:asset_id).should eq [32459]
      end
    end
  end
end
