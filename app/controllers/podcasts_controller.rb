class PodcastsController < ApplicationController
  
  def index
    @podcasts = Podcast.order("title asc").listed
  end
  
  #----------
  
  def podcast
    # is this valid?
    @podcast = Podcast.where(:slug => params[:slug]).first
    @obj_type = nil
    
    if !@podcast
      # not valid... 
      render :text => "Invalid podcast slug.", :status => :not_found and return
    end
    
    response.headers["Content-Type"] = 'text/xml'

    # check if we have a cached podcast.  If so, short-circuit and return it
    if cache = Rails.cache.fetch("podcast:#{@podcast.id}")
      render :text => cache, :formats => [:xml] and return
    end
    
    @content = nil
    if @podcast.item_type == "episodes"
      @content = ( @podcast.program ? @podcast.program.episodes : ShowEpisode ).published
      @obj_type = "shows/episode:new"
    elsif @podcast.item_type == "segments"
      @content = ( @podcast.program ? @podcast.program.segments : ShowSegment ).published
      @obj_type = "shows/segment:new"
    elsif @podcast.item_type == "content"
      # TBD
      @obj_type = "contentbase:new"
      
    else
      # nothing...
    end
    
    # if we have content, grab 25 items and collect only those with audio
    if @content
      @content = @content.first(25).collect { |c| c.audio.any? ? c : nil }.compact

      # we limit podcasts to 15 items
      @content = @content.first(15)
    end    
        
    xml = render_to_string :formats => [:xml]
    
    Rails.cache.write_entry("podcast:#{@podcast.id}",xml,:objects => [@content,@obj_type].flatten)
    
    render :text => xml, :formats => [:xml]
  end
  
  #----------
  
  
end