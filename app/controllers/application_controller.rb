class ApplicationController < ActionController::Base
  include Outpost::Controller::CustomErrors
  
  protect_from_forgery
  before_filter :get_content_for_masthead
  before_filter :add_params_for_newrelic

  def add_params_for_newrelic
    NewRelic::Agent.add_custom_parameters(
      :request_referer => request.referer, 
      :agent           => request.env['HTTP_USER_AGENT']
    )
  end

  #----------

  private

  def get_content_for_masthead
    @upcoming_events_forum      = Event.published.includes(:assets).upcoming.forum.limit(2)
    @upcoming_events_sponsored  = Event.published.includes(:assets).upcoming.sponsored.limit(3)
    @latest_blogs_news          = BlogEntry.published.includes(:blog).where(Blog.table_name => { is_news: true }).limit(3)
    @latest_blogs_arts          = BlogEntry.published.includes(:blog).where(Blog.table_name => { is_news: false }).limit(3)
  end

  #----------
  # Override this method from CustomErrors to set the layout
  def render_error(status, e=StandardError)
    super
    report_error(e)
  end

  #----------
  # Enforce both Upper and Lower page limits.
  # Pass in the results per page.
  def enforce_page_limits(per_page)
    enforce_page_lower_limit
    enforce_page_upper_limit(per_page)
  end

  #----------
  # Enforce Lower page limit. This will not allow a page
  # number to be below 1
  def enforce_page_lower_limit
    if params[:page] && params[:page].to_i < 1
      params[:page] = 1
    end
  end

  #----------
  # Enforce an upper limit. Only necessary with Sphinx results.
  def enforce_page_upper_limit(per_page)
    # Reset to page 1 if the requested page is too high
    # Otherwise an error will occur
    # TODO: Fallback to SQL query instead of just cutting it off.
    if params[:page] && params[:page].to_i > (SPHINX_MAX_MATCHES / per_page.to_i)
      params[:page] = 1 
    end
  end
end
