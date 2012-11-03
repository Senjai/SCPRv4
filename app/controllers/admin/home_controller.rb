class Admin::HomeController < Admin::BaseController
  def index
    # Grab registered model groups for the Navigation
    @nav_groups = AdminResource.config.nav_groups
    
    # Gather some data for stats
    @latest_story = get_latest_story
    
    @recent_stories  = NewsStory.published.where("published_at >= ?", 1.hour.ago)
    @latest_homepage = Homepage.published.first
    
    # Get the latest activity
    @current_user_activities = @admin_user.activities.order("created_at desc").limit(5)
    @latest_activities       = Secretary::Version.order("created_at desc").where("user_id != ?", @admin_user.id).limit(5)
  end
  
  private
  def get_latest_story
    begin
      ThinkingSphinx.search('',
        :classes    => ContentBase.content_classes,
        :order      => :published_at,
        :sort_mode  => :desc,
        :limit      => 1,
      ).first
    rescue Riddle::ConnectionError
      nil
    end
  end
end
