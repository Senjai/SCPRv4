class ContentAsset < ActiveRecord::Base  
  self.table_name =  "assethost_contentasset"
  self.primary_key = "id"
  
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  
  @@loaded = false
  
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
  
  #----------
  # Fetch asset JSON and then merge in our caption and position
  def as_json(options={})
    # grab asset as_json, merge in our values
    self.asset.as_json(options).merge!({
      "content_asset_id" => self.id,
      "caption"          => self.caption, 
      "ORDER"            => self.asset_order, 
      "credit"           => self.asset.owner
    })
  end

  #----------
  # This is for the asset manager
  def simple_json
    {
      "id"          => self.asset_id,
      "caption"     => self.caption,
      "asset_order" => self.asset_order.to_i
    }
  end
end
