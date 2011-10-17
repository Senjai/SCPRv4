class ContentAsset < ActiveRecord::Base
  set_table_name "rails_assethost_contentasset"
  
  belongs_to :object, :polymorphic => true
  #belongs_to :asset
    
  #----------
  
  def asset 
    @_asset ||= Asset.find(self.asset_id)
  end
  
end