class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_session, :set_up_finders
  
  helper_method :current_user
  
  def current_user
    @current_user
  end
  
  private
  
  def set_up_finders
    @g_upcoming_events_forum = Event.published.upcoming.forum.limit(4)
    @g_upcoming_events_sponsored = Event.published.upcoming.sponsored
    
    # FIXME: Isn't there a way to do this without hardcoding the table name in the where clause?
    @g_latest_blogs_news = BlogEntry.published.joins(:blog).where("blogs_blog.is_news = true").order("published_at desc")
    @g_latest_blogs_arts = BlogEntry.published.joins(:blog).where("blogs_blog.is_news = false").order("published_at desc")
  end
  
  def check_session
    if session[:user_id]
      @current_user = UserProfile.find(session[:user_id])
    end
  rescue
    @current_user = nil
  end
end
