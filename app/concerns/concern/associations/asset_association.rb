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
        has_many :assets, class_name: "ContentAsset", as: :content, order: "asset_order", dependent: :destroy
        accepts_nested_attributes_for :assets, allow_destroy: true        
        
        attr_accessor :asset_json
        after_save :parse_asset_json
      end
      
      #-------------------
      
      def parse_asset_json
        if self.asset_json.present?
          Rails.logger.info "*** #{self.asset_json}"
        end
      end
    end # AssetAssociation
  end # Associations
end # Concern
