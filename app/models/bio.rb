class Bio < ActiveRecord::Base
  self.table_name =  'bios_bio'
  
  belongs_to :user
  
  #----------
  
  def content(page=1)
    ContentByline.search('', 
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :user_id => self.id },
      :per_page   => 15,
      :page       => page
    )
  end
  
  #----------
  
  def to_param
    "#{slugged_name}"
  end
  
  def twitter_url
    if twitter.present?
      "http://twitter.com/#{twitter.gsub(/@/, '')}"
    end
  end
  
  def headshot
    if self.asset_id?
      @_asset ||= Asset.find(self.asset_id)
    else
      return false
    end
  end
end