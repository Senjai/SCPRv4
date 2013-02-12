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
          :order      => "asset_order", 
          :dependent  => :destroy,
          :autosave   => true
        }
        
        #-------------------
        # #asset_json is a way to pass in a string representation
        # of a javascript object to the model, which will then be
        # parsed and turned into ContentAsset objects in the 
        # #asset_json= method.
        #
        # This gets populated in the form by javascript
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
      # ContentAsset objects. 
      def asset_json=(json)
        # If this is literally an empty string (as opposed to an 
        # empty JSON object, which is what it would be if there were no assets),
        # then we can assume something went wrong and just abort.
        #
        # Since javascript is populating the json field on load (to keep
        # us from having to bootstrap it here), it's possible that the javascript
        # won't load and the field will never get populated, in which case, if we
        # tried to save, this method would clear out all of the assets, which
        # would be incorrect.
        return if json.empty?
        
        json = Array(JSON.parse(json)).sort_by { |c| c["asset_order"].to_i }
        loaded_assets = []
        
        json.each do |asset_hash|
          new_asset = ContentAsset.new(
            :asset_id    => asset_hash["id"].to_i, 
            :caption     => asset_hash["caption"].to_s, 
            :asset_order => asset_hash["asset_order"].to_i
          )
          
          loaded_assets.push new_asset
        end
        
        self.assets = loaded_assets
      end
    end # AssetAssociation
  end # Associations
end # Concern
