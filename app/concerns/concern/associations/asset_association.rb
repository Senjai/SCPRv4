##
# AssetAssociation
#
# Association for Asset
#
module Concern
  module Associations
    module AssetAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :assets, {
          :class_name => "ContentAsset", 
          :as         => :content, 
          :order      =>"asset_order", 
          :dependent  => :destroy,
          :autosave   => true
        }
        
        # #asset_json is a way to pass in a string representation
        # of a javascript object to the model, which will then be
        # parsed and turned into ContentAsset objects in the 
        # #parse_asset_json method.
        attr_accessor :asset_json
        before_save :parse_asset_json
      end
      
      #-------------------
      # Parse the input from #asset_json and turn it into real
      # ContentAsset objects. If an asset with this ID already
      # exists for this object, just update the caption and
      # asset_order. Otherwise, create a ContentAsset object.
      def parse_asset_json
        # Blank asset_json means no assets were modified.
        # Return and carry on
        return if self.asset_json.blank?
        @_loaded_assets = []
        
        Array(JSON.load(self.asset_json)).each do |asset_hash|
          @_loaded_assets.push Asset::Simple.new(asset_hash)
        end
        
        make_assets
        remove_assets
        true
      end

      #-------------------
      
      private
      
      #-------------------
      # If the record isn't persisted, then it has no 
      # persisted assets yet, so just move right on to
      # building a new asset.
      #
      # If it's persisted but this asset doesn't yet
      # exist for this record, then also build a new 
      # asset.
      #
      # If the record is persisted and the asset already
      # exists, then just update the caption and order
      # attributes.
      #
      # Everything will be saved when the record is saved.
      def make_assets
        @_loaded_assets.each do |asset|
          if self.persisted? && (existing = existing_asset(asset.id))
            existing.caption     = asset.caption
            existing.asset_order = asset.asset_order
          else
            self.assets.build(asset_id: asset.id, caption: asset.caption, asset_order: asset.asset_order)
          end
        end
      end

      #-------------------
      # Mark for destruction any assets that exist for
      # this record but do not exist in the asset_json
      # They will be destroyed when the record is saved.
      def remove_assets
        self.assets.select { |a| !asset_passed_in?(a.asset_id) }.each do |asset|
          asset.mark_for_destruction
        end        
      end

      #-------------------
      # Check if asset_id exists in
      # this record's assets already
      def existing_asset(asset_id)
        self.assets.find { |a| a.asset_id == asset_id }
      end

      #-------------------
      # Check if asset_id was passed
      # in to the model via asset_json
      def asset_passed_in?(asset_id)
        @_loaded_assets.map(&:id).include?(asset_id)
      end
    end # AssetAssociation
  end # Associations
end # Concern
