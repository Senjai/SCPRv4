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

      def asset
        @asset ||= self.assets.first
      end
    end # AssetAssociation
  end # Associations
end # Concern
