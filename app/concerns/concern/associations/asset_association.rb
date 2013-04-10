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
          :order      => "position", 
          :dependent  => :destroy,
          :autosave   => true
        }

        accepts_json_input_for_assets
      end

      #-------------------
      # Return the first asset in the given medium and size.
      # Returns nil if no assets are present.
      def primary_asset(size, format=:tag)
        self.assets.first.asset.send(size).send(format) if self.assets.present?
      end
    end # AssetAssociation
  end # Associations
end # Concern
