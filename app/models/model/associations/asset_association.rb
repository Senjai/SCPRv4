##
# AssetAssociation
#
# Association for Asset
#
module Model
  module Associations
    module AssetAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :assets, class_name: "ContentAsset", as: :content, order: "asset_order", dependent: :destroy
      end
    end
  end
end
