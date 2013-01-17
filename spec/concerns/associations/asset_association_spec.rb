require "spec_helper"

describe Concern::Associations::AssetAssociation do
  subject { TestClass::Story.new }
  
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
  
  describe "#asset_json=" do
    context "no asset_json passed in" do
      it "doesn't do anything" do
        newrecord = TestClass::Story.create!(asset_json: "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]", headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        newrecord.assets.size.should eq 1
        
        record = TestClass::Story.find(newrecord.id)
        record.save!
        record.assets.size.should eq 1
      end
    end
    
    context "for new record" do
      it "parses the json and adds the asset on save" do
        record = TestClass::Story.new(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]"
        record.assets.size.should eq 1
        record.save!
        record.reload.assets.size.should eq 1
        record.assets.first.caption.should eq "Caption"
        record.assets.first.asset_order.should eq 12
      end
      
      it "runs #asset_json= when passig it in to .new" do
        record = TestClass::Story.new(asset_json:  "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]", headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        record.assets.size.should eq 1
      end
    end
    
    context "updating assets" do
      it "replaces the collection with the new one" do
        record = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
        record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"asset_order\":12}]"
        record.assets.size.should eq 1
        record.save!
        
        record.asset_json = "[{\"id\":32450,\"caption\":\"Other Caption\",\"asset_order\":1}]"
        record.assets.size.should eq 1
        record.assets.first.caption.should eq "Other Caption"
        record.save!
        
        # Make sure it actually deleted the other asset
        ContentAsset.count.should eq 1
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
