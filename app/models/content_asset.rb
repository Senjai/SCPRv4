class ContentAsset < ActiveRecord::Base  
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
  
  #----------
  # Fetch asset JSON and then merge in our caption and position
  def as_json(options={})
    # grab asset as_json, merge in our values
    self.asset.as_json(options).merge!({
      "content_asset_id" => self.id.to_i,
      "caption"          => self.caption.to_s, 
      "ORDER"            => self.position.to_i, 
      "credit"           => self.asset.owner.to_s
    })
  end

  #----------
  # This is for the asset manager
  def simple_json
    {
      "id"          => self.asset_id,
      "caption"     => self.caption,
      "position"    => self.position.to_i
    }
  end
end
