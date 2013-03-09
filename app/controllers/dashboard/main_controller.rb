class Dashboard::MainController < ApplicationController

  skip_before_filter :set_up_finders, :check_sessions, :add_params_for_newrelic, only: :notify
  
  def notify
    if params[:auth_token] != Rails.application.config.api['assethost']['token']
      render text: "Unauthorized", status: :unauthorized
      return false
    end
    
    redis = Rails.cache.instance_variable_get :@data
    
    data = {
      :user        => params["user"],
      :datetime    => params["datetime"],
      :application => params["application"]
    }
    
    logger.info "Publishing deploy notification to Redis on channel scprdeploy"
    redis.publish "scprdeploy", data.to_json
    render text: "Success", status: :ok
  end
    
  def index
    # get a baseline published stories count
    @baseline = NewsStory.published.since(7.days.ago)
    
    # fetch news stories from the last seven days with no category
    @stories = @baseline.joins(
      "left join contentbase_contentcategory on `contentbase_contentcategory`.`content_id` = `news_story`.`id` AND `contentbase_contentcategory`.`content_type` = 'NewsStory'"
    ).where(
      "`contentbase_contentcategory`.`id` is null"
    ).order("published_at desc")
    
    @no_assets = @baseline.joins(
      "left join `assethost_contentasset` on `assethost_contentasset`.content_id = news_story.id and `assethost_contentasset`.content_type = 'NewsStory'"
    ).where("assethost_contentasset.id is null").order("published_at desc")
    
    @blog_no_assets = BlogEntry.published.since(7.day.ago).joins(
      "left join contentbase_contentcategory on `contentbase_contentcategory`.`content_id` = `blogs_entry`.`id` AND `contentbase_contentcategory`.`content_type` = 'BlogEntry'"
    ).joins(
      "left join `assethost_contentasset` on `assethost_contentasset`.content_id = blogs_entry.id and `assethost_contentasset`.content_type = 'BlogEntry'"
    ).where("`contentbase_contentcategory`.`id` is not null").where("assethost_contentasset.id is null").order("published_at desc")
  end

  #----------
  
  def sections
    @homepage = Homepage.published.first
    
    scored_content = @homepage.scored_content
    
    @sections = scored_content[:sections]
  end
  
  #----------
  
  def enco
    @awaiting  = Audio::EncoAudio.awaiting_audio.count
    @this_week = Audio::EncoAudio.awaiting_audio.where( :enco_date => Date.today-7..Date.today ).order("enco_date desc, enco_number asc")
  end
end
