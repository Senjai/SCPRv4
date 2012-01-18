class Dashboard::MainController < ApplicationController
  
  def index
    # get a baseline published stories count
    @baseline = NewsStory.published.this_week
    
    # fetch news stories from the last seven days with no category
    @stories = @baseline.joins(
      "left join rails_contentbase_contentcategory on `rails_contentbase_contentcategory`.`content_id` = `news_story`.`id` AND `rails_contentbase_contentcategory`.`content_type` = 'NewsStory'"
    ).where(
      "`rails_contentbase_contentcategory`.id is null"
    ).order("published_at desc")
    
    # and news stories published in the last seven days with no assets
    @no_assets = @baseline.joins(
      "left join `rails_assethost_contentasset` on `rails_assethost_contentasset`.content_id = news_story.id and `rails_assethost_contentasset`.content_type = 'NewsStory'"
    ).where("rails_assethost_contentasset.id is null").order("published_at desc")
  end

  #----------
  
  def sections
    # empty array for sections
    @sections = []
    
    # grab the last three stories for each section
    Category.all.each do |cat|
      content = ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 4,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => cat.id }
      
      top = nil
      more = []
      sorttime = nil
      
      content.each do |c|
        ctime = c.public_datetime.is_a?(Date) ? c.public_datetime.to_time : c.public_datetime
        
        # if we're still here, weigh this content for sorting
        if !sorttime || ctime > sorttime
          sorttime = ctime
        end
      end  
      
      sec = {
        :section  => cat,
        :content  => content,
        :sorttime => sorttime
      }
      
      # -- first look for featured comments -- #
      
      featured = sec[:section].comment_bucket.comments.published
      
      if featured.any?
        sec[:featured] = featured.first
      end
      
      # -- now try slideshows -- #
      
      content = ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 1,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => sec[:section].id, :is_slideshow => true }
        
      if content
        sec[:slideshow] = content.first
      end

      # -- segment in the last two days? -- #
      
      segments = ThinkingSphinx.search '',
        :classes    => [ShowSegment],
        :page       => 1,
        :per_page   => 1,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => sec[:section].id }
        
      if segments
        sec[:segment] = segments.first
      end      
      
      # assemble section object
      @sections << sec
    end
    
    
    # sort by newest
    @sections.sort_by! {|s| s[:sorttime] }.reverse!  
  end
  
end