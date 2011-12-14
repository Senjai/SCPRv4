class ContentAsset < ActiveRecord::Base
  set_table_name "rails_assethost_contentasset"
  
  belongs_to :content, :polymorphic => true
  #belongs_to :asset
    
  #----------
  
  def asset
    if @_asset
      return @_asset
    end
    
    key = "asset/#{self.content&&self.content.obj_key}-#{self.asset_id}"
    
    # otherwise, check for cache
    if @_asset = ActionController::Base.cache_store.read_entry(key,{})
      return @_asset
    else
      # load
      @_asset = Asset.find(self.asset_id)

      # write cache that can be expired by content or asset
      ActionController::Base.cache_store.write_entry(key,@_asset,:objects => [self.content,@_asset])
      
      return @_asset
    end
  end
  
end