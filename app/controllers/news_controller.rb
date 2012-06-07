class NewsController < ApplicationController
  respond_to :html, :js
  
  caches_action :story, :if => Proc.new { params[:id] == "32724" }
  
  def story
    begin
      @story = NewsStory.published.find(params[:id])
    rescue
      # if this story doesn't exist or hasn't been published, send them to the home page
      redirect_to home_path and return
    end
    
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @story.link_path
      redirect_to @story.link_path and return
    end
    
    # otherwise, just render
  end
  
  #----------
  
  # map old /news/YYYY/MM/DD/slug URLs to the correct one with ID
  def old_story
    date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    
    stories = NewsStory.published.where("published_at > ? and published_at < ? and slug = ?",date,(date+1),params[:slug])
    
    redirect_to stories.any? ? stories.first.link_path : home_path, :permanent => true
  rescue
    redirect_to home_path    
  end
end
