class PodcastsController < ApplicationController
  
  def index
    
  end
  
  #----------
  
  def podcast
    # is this valid?
    @podcast = Podcast.where(:slug => params[:slug]).first
    
    if !@podcast
      # not valid... 
      render :text => "Invalid podcast slug.", :status => :not_found and return
    end
    
    @content = nil
    if @podcast.item_type == "episodes"
      @content = ( @podcast.program ? @podcast.program.episodes : ShowEpisode ).published
    elsif @podcast.item_type == "segments"
      @content = ( @podcast.program ? @podcast.program.segments : ShowSegment ).published
    elsif @podcast.item_type == "content"
      # TBD
    else
      # nothing...
    end
    
    # if we have content, grab 25 items and collect only those with audio
    if @content
      @content = @content.first(25).collect { |c| c.audio.any? ? c : nil }.compact
    end
    
    Rails.logger.debug "content is #{@content}"
    
    render "podcast.xml"
  end
  
  #----------
  
  
end