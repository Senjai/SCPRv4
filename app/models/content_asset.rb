class ContentAsset < ActiveRecord::Base
  include Outpost::AssetHost::JoinModelJson
  
  self.table_name =  "assethost_contentasset"
  
  belongs_to :content, polymorphic: true
  
  #----------
  
  def asset
    if @_asset
      return @_asset
    end

    # otherwise load it
    @_asset = Asset.find(self.asset_id)
    
    # Catch a fallback and push in a caption
    if @_asset.is_a? Asset::Fallback
      self.caption = "We encountered a problem, and this photo is currently unavailable."
    end
    
    return @_asset
  end
end
