class Bio < ActiveRecord::Base
  self.table_name =  'bios_bio'
  
  belongs_to  :user,    class_name: "AdminUser"
  has_many    :bylines, class_name: "ContentByline",  foreign_key: :user_id
  
  #----------
  
  def indexed_bylines(page=1, per_page=15)
    # Sphinx max_matches limits how much it can offset results, so for Bios with a lot
    # of pages of Bylines, we have to fallback to an actual SQL query if the offset is
    # too high. Run some Ruby methods on the byines to mimic SQL's order and conditions.
    if page.to_i > (SPHINX_MAX_MATCHES / per_page.to_i)
      bylines = self.bylines.includes(:content)
                    .paginate(page: page, per_page: per_page).all
                    
      bylines.select  { |b| b.content.status == ContentBase::STATUS_LIVE}
             .sort_by { |b| b.content.published_at }
             .reverse
    else
      ContentByline.search('', 
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :user_id => self.id, status: ContentBase::STATUS_LIVE },
        :per_page   => per_page,
        :page       => page
      )
    end
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