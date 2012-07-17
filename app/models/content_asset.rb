class ContentAsset < ActiveRecord::Base
  map_content_type_for_django
  
  self.table_name =  "assethost_contentasset"
  self.primary_key = "id"
    
  belongs_to :content, :polymorphic => true
  
  @@loaded = false
  
  #----------
  
  def asset
    if @_asset
      return @_asset
    end

    # otherwise load it
    @_asset = Asset.find(self.asset_id)
    return @_asset
  end
  
  #----------
  
  # Fetch asset JSON and then merge in our caption and position
  def as_json(options={})
    # grab asset as_json, merge in our values, then call to_json on that
    self.asset.as_json(options).merge({"caption" => self.caption, "ORDER" => self.asset_order, "credit" => self.asset.owner })
  end
  
end