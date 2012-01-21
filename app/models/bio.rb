class Bio < ActiveRecord::Base
  self.table_name =  'bios_bio'
  
  belongs_to :user
  
  def headshot
    if self.asset_id?
      @_asset ||= Asset.find(self.asset_id)
    else
      return false
    end
  end
end