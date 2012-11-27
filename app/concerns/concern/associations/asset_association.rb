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
      end
    end # AssetAssociation
  end # Associations
end # Concern
