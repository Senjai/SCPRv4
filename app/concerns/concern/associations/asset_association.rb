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
        # #asset_json= method.
        #
        # The reader is only for the form and doesn't need to be
        # automatically populated.
        attr_reader :asset_json
      end

      #-------------------
      # Return the first asset in the given medium and size.
      # Returns nil if no assets are present.
      def primary_asset(size, format=:tag)
        self.assets.first.asset.send(size).send(format) if self.assets.present?
      end
      
      #-------------------
      # Parse the input from #asset_json and turn it into real
      # ContentAsset objects. If an asset with this ID already
      # exists for this object, just update the caption and
      # asset_order. Otherwise, create a ContentAsset object.
      def asset_json=(json)
        # Blank json means no assets were modified.
        # Return and carry on
        return if json.blank?
        
        @_loaded_assets = []
        
        Array(JSON.load(json)).each do |asset_hash|
          asset = ContentAsset.new(
            :asset_id    => asset_hash["id"].to_i, 
            :caption     => asset_hash["caption"].to_s, 
            :asset_order => asset_hash["asset_order"].to_i
          )

          @_loaded_assets.push asset
        end
        
        self.assets = @_loaded_assets
      end
    end # AssetAssociation
  end # Associations
end # Concern
