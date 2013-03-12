class ApplicationController < ActionController::Base
  include Concern::Controller::CustomErrors
  
  protect_from_forgery
  before_filter :set_up_finders
  before_filter :add_params_for_newrelic

  def add_params_for_newrelic
    NewRelic::Agent.add_custom_parameters(request_referer: request.referer, agent: request.env['HTTP_USER_AGENT'])
  end

  #----------
  
  protected

  def raise_404
    raise ActionController::RoutingError.new("Not Found")
  end

  #----------
    
  private

  def set_up_finders
    @g_upcoming_events_forum = Event.published.upcoming.forum.limit(4)
    @g_upcoming_events_sponsored = Event.published.upcoming.sponsored
  
    # FIXME: Isn't there a way to do this without hardcoding the table name in the where clause?
    @g_latest_blogs_news = BlogEntry.published.joins(:blog).where("blogs_blog.is_news = true").order("published_at desc")
    @g_latest_blogs_arts = BlogEntry.published.joins(:blog).where("blogs_blog.is_news = false").order("published_at desc")
  end

  #----------
  # Override this method from CustomErrors to set the layout
  def render_error(status, e=StandardError)
    respond_to do |format|
      format.html { render template: "/errors/error_#{status}", status: status, layout: "app_nosidebar", locals: { error: e } }
      format.xml { render xml: { error: status.to_s }, status: status }
      format.text { render text: status, status: status}
    end
    
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
