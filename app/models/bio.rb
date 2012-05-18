class Bio < ActiveRecord::Base
  self.table_name =  'bios_bio'
  
  belongs_to :user
  
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