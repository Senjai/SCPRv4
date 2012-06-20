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
    
    @content = nil
    if @podcast.item_type == "episodes"
      @content = ( @podcast.program ? @podcast.program.episodes : ShowEpisode ).published
      @obj_type = "shows/episode:new"
    elsif @podcast.item_type == "segments"
      @content = ( @podcast.program ? @podcast.program.segments : ShowSegment ).published
      @obj_type = "shows/segment:new"
    elsif @podcast.item_type == "content"
      @obj_type = "contentbase:new"
      
      @content = ThinkingSphinx.search '', 
        :with       => { :has_audio => true }, 
        :without    => { :category => '' },
        :classes    => ContentBase.content_classes, 
        :order      => :published_at, 
        :page       => 1, 
        :per_page   => 15, 
        :sort_mode  => :desc
    else
      # nothing...
    end
    
    if @content
      # We only care about the latest 25 items
      @content = @content.first(25)
      
      # Set up the actual podcast listing, only items with audio
      # Limit it to 15 items
      @audio_content = @content.select { |c| c.audio.present? }.first(15)
    end    
        
    xml = render_to_string :formats => [:xml]    
    render :text => xml, :formats => [:xml]
  end
  
  #----------
  
  
end