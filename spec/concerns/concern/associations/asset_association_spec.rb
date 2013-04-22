require "spec_helper"

describe Concern::Associations::AssetAssociation do
  
  #--------------------

  describe '#asset_json' do
    it "uses simple_json for the asset" do
      record = create :test_class_story
      asset = create :asset, caption: "Hello", asset_id: 999, position: 4
      record.assets << asset
      record.save!

      record.asset_json.should eq [asset.simple_json].to_json
      record.assets.should eq [asset]
    end
  end

  #--------------------

  describe "assets_changed?" do
    it "is true on initialize" do
      newrecord = build :test_class_story, asset_json: "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
      newrecord.assets_changed?.should eq true
    end

    it "is false if the assets have not changed" do
      original_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
      
      newrecord = create :test_class_story, asset_json: original_json
      newrecord.asset_json = original_json

      newrecord.assets_changed?.should eq false
    end

    it "is false after the record has been saved" do
      newrecord = build :test_class_story, asset_json: "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
      newrecord.assets_changed?.should eq true
      newrecord.save!

      newrecord.assets_changed?.should eq false
    end
  end

  describe "#asset_json=" do
    context "create with asset_json passed in" do
      it "creates assets" do
        newrecord = create :test_class_story, asset_json: "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
        newrecord.reload.assets.size.should eq 1
      end
    end
    
    it "doesn't do anything if passed-in argument is an empty string" do
      record = create :test_class_story
      record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
      record.assets.size.should eq 1
      
      record.asset_json = ""
      record.assets.size.should eq 1

      record.asset_json = "[]"
      record.assets.size.should eq 0
    end
    
    it "adds them ordered by position" do
      record = create :test_class_story
      record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}, {\"id\":32458,\"caption\":\"Other Caption\",\"position\":0}]"
      record.assets.map(&:position).should eq [0, 12]
    end
    
    context "for new record" do
      it "parses the json and adds the asset" do
        record = build :test_class_story
        record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
        record.assets.size.should eq 1
        record.save!
        record.reload.assets.size.should eq 1
      end
      
      it "Doesn't create the association if run in a rollback transaction" do
        record = create :test_class_story
        record.assets.size.should eq 0
        
        record.transaction do
          record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
          record.assets.size.should eq 1
          raise ActiveRecord::Rollback
        end
        
        record.reload
        record.assets.size.should eq 0
      end
    end
    
    context "updating assets" do
      it "replaces the collection with the new one" do
        record = create :test_class_story
        record.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
        record.assets.size.should eq 1
        record.save!
        
        record.asset_json = "[{\"id\":32450,\"caption\":\"Other Caption\",\"position\":1}]"
        record.assets.size.should eq 1
        record.assets.first.caption.should eq "Other Caption"
        record.save!
        
        # Make sure it actually deleted the other asset
        ContentAsset.count.should eq 1
      end
    end

    context "when no assets have changed" do
      it "doesn't set the assets" do
        original_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
        record = create :test_class_story, asset_json: original_json

        record.should_not_receive :assets=
        record.asset_json = original_json
      end
    end
  end
end
