class HomeController < ApplicationController  
  layout "homepage"
  
  # Just for development purposes
  # Pass ?regenerate to the URL to regenerate the homepage category blocks
  # Only works in development
  before_filter :generate_homepage, only: :index, if: -> { Rails.env == "development" && params.has_key?(:regenerate) }
  
  def index
    @homepage = Homepage.published.first
    @schedule_current = Schedule.on_at(Time.now).first
  end

  # Elections - Remove this!
  def elections
    @data        = DataPoint.where(group_name: 'election')
    @data_points = DataPoint.to_hash(@data)
    @category    = Category.find_by_slug('politics')
    
    @content = ContentBase.search({
      :limit => 15,
      :with  => { category: [@category.id] }
    })
  end
  
  #----------
  
  def listen
    render layout: 'application'
  end
  
  def about_us
    render :layout => "app_nosidebar"
  end
  
  def error
    render :template => "/error/500.html", :status => 500, :layout => "app_nosidebar"
  end
  
  def not_found
    render :template => "/error/404.html", :status => 404, :layout => "app_nosidebar"
  end
    
  #----------
  
  def missed_it_content
    @homepage = Homepage.find(params[:id])
    @carousel_contents = @homepage.missed_it_bucket.contents.page(params[:page]).per(6)
    render 'missed_it_content.js.erb'
  end
  
  protected
  
  def generate_homepage
    CacheTasks::Homepage.new.run
  end
end
