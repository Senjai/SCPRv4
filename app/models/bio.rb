class Bio < ActiveRecord::Base
  self.table_name =  'bios_bio'
  
  belongs_to :user
  
  #----------
  
  def content(page=1)
    ContentByline.search('', 
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :user_id => self.id },
      :per_page   => 20,
      :page       => page
    ).collect &:content
  end
  
  #----------
  
  def headshot
    if self.asset_id?
      @_asset ||= Asset.find(self.asset_id)
    else
      return false
    end
  end
end