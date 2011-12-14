class ContentAsset < ActiveRecord::Base
  set_table_name "rails_assethost_contentasset"
  
  belongs_to :content, :polymorphic => true
  #belongs_to :asset
  
  @@loaded = false
  
    
  #----------
  
  def asset
    if @_asset
      return @_asset
    end
    
    key = "asset/#{self.content&&self.content.obj_key}-#{self.asset_id}"
    
    # otherwise, check for cache
    Rails.logger.debug("CA loaded is #{@@loaded}")
    if @@loaded && a = Rails.cache.read(key)
      @_asset = a
      return @_asset
    else
      # load
      @_asset = Asset.find(self.asset_id)

      # write cache that can be expired by content or asset
      Rails.cache.write(key,@_asset,:objects => [self.content,@_asset])
      
      @@loaded = true
      
      return @_asset
    end
  end
  
end