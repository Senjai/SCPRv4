class ContentAsset < ActiveRecord::Base
  include Outpost::AssetHost::JoinModelJson
  
  self.table_name =  "assethost_contentasset"
  
  belongs_to :content, polymorphic: true
  
  delegate :title, :size, 
    :taken_at, :owner, :url, :api_url, 
    :native, :image_file_size,
    :lsquare, :small, :eight, :full, 
    to: :asset

  #----------
  
  def asset
    @asset ||= begin
      _asset = AssetHost::Asset.find(self.asset_id)

      if _asset.is_a? AssetHost::Asset::Fallback
        self.caption = "We encountered a problem, and this photo is currently unavailable."
      end
    
      _asset
    end
  end
end
