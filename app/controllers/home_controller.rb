class HomeController < ApplicationController  
  layout "homepage"
  before_filter :get_latest_videos, only: [:index]

  # Just for development purposes
  # Pass ?regenerate to the URL to regenerate the homepage category blocks
  # Only works in development
  before_filter :generate_homepage, only: :index, if: -> { Rails.env == "development" && params.has_key?(:regenerate) }
  
  def index
    @homepage = Homepage.published.first
    @schedule_current = Schedule.on_at(Time.now).first
  end
  
  #----------
  
  def listen
    render layout: 'application'
  end
  
  def about_us
    render layout: "app_nosidebar"
  end
  
  def not_found
    render_error(404)
  end

  def trigger_error
    raise Exception, "This is a test error. It works (or does it?)"
  end
  
  #----------
  
  def missed_it_content
    @homepage = Homepage.find(params[:id])
    @carousel_contents = @homepage.missed_it_bucket.contents.page(params[:page]).per(6)
    render 'missed_it_content', formats: [:js]
  end
  
  protected
  
  def generate_homepage
    CacheTasks::Homepage.new.run
  end

  def get_latest_videos
    @latest_videos = VideoShell.published.limit(5)
  end
end
