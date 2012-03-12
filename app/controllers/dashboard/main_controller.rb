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
    
    @no_assets = @baseline.joins(
      "left join `rails_assethost_contentasset` on `rails_assethost_contentasset`.content_id = news_story.id and `rails_assethost_contentasset`.content_type = 'NewsStory'"
    ).where("rails_assethost_contentasset.id is null").order("published_at desc")
    
    @blog_no_assets = BlogEntry.published.this_week.joins(
      "left join rails_contentbase_contentcategory on `rails_contentbase_contentcategory`.`content_id` = `blogs_entry`.`id` AND `rails_contentbase_contentcategory`.`content_type` = 'BlogEntry'"
    ).joins(
      "left join `rails_assethost_contentasset` on `rails_assethost_contentasset`.content_id = blogs_entry.id and `rails_assethost_contentasset`.content_type = 'BlogEntry'"
    ).where("`rails_contentbase_contentcategory`.id is not null").where("rails_assethost_contentasset.id is null").order("published_at desc")
  end

  #----------
  
  def sections
    @homepage = Homepage.published.first
    
    scored_content = @homepage.scored_content
    
    @sections = scored_content[:sections]
  end
  
  #----------
  
  def listen
    @current = params[:current] ? true : false
    
    # grab eight hours worth of schedule, starting six hours ago
    @schedule = Schedule.at :time => Time.now() - 60*60*6, :hours => 8
  end
  
end