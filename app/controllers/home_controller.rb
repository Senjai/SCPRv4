class HomeController < ApplicationController  
  layout "homepage"

  # Just for development purposes
  # Pass ?regenerate to the URL to regenerate the homepage category blocks
  # Only works in development
  before_filter :generate_homepage, only: :index, if: -> { %w{development staging}.include?(Rails.env) && params.has_key?(:regenerate) }
  
  def index
    @homepage         = Homepage.published.first
    @schedule_current = Schedule.on_at(Time.now).first
    @featured_comment = FeaturedComment.published.first

    # May Elections
    @data_points    = DataPoint.where(group_name: "election-may2013")
      .where("data_key like ? or data_key like ? or data_key like ? or data_key like ?", "mayor%", "attorney%", "prop_d%", "ord%")
      .order('id asc')
    
    @cache_control  = DataPoint.to_hash(DataPoint.where(group_name: "cache-control"))

  end
  
  #----------
  
  def listen
    render layout: 'application'
  end
  
  def about_us
    render layout: "app_nosidebar"
  end
  
  def not_found
    render_error(404, ActionController::RoutingError.new("Not Found"))
  end

  def trigger_error
    raise StandardError, "This is a test error. It works (or does it?)"
  end
  
  #----------
  
  def missed_it_content
    @homepage = Homepage.includes(:missed_it_bucket).find(params[:id])
    @carousel_contents = @homepage.missed_it_bucket.content.includes(:content).page(params[:page]).per(6)
    render 'missed_it_content', formats: [:js]
  end
  
  
  protected
  
  def generate_homepage
    Job::HomepageCache.perform
  end
end
