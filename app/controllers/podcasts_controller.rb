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
    setup_range_headers if request.headers["Range"].present?

    @content = nil
    if @podcast.item_type == "episodes"
      @content = ( @podcast.program ? @podcast.program.episodes : ShowEpisode ).published
      @obj_type = "shows/episode:new"
    elsif @podcast.item_type == "segments"
      @content = ( @podcast.program ? @podcast.program.segments : ShowSegment ).published
      @obj_type = "shows/segment:new"
    elsif @podcast.item_type == "content"
      @obj_type = "contentbase:new"
      
      @content = ThinkingSphinx.search('', 
        :with       => { :has_audio => true }, 
        :without    => { :category => '' },
        :classes    => ContentBase.content_classes, 
        :order      => :published_at, 
        :page       => 1, 
        :per_page   => 15, 
        :sort_mode  => :desc,
        retry_stale: true

      )
    else
      # nothing...
    end
    
    if @content
      # We only care about the latest 25 items
      @content = @content.first(25)
      
      # Set up the actual podcast listing, only items with audio
      # Limit it to 15 items
      @audio_content = @content.select { |c| c.audio.available.present? }.first(15)
    end

    render_to_string formats: [:xml]
  end
  
  protected
    def setup_range_headers
      # Fake the headers for iTunes.
      response.headers["Status"]         = "206 Partial Content"
      response.headers["Accept-Ranges"]  = "bytes"
      
      request.headers["Range"].match(/bytes ?= ?(\d+)-(\d+)?/) do |match|        
        rangeStart, rangeEnd        = match[1].to_i, match[2].to_i
        rangeLength                 = (rangeEnd - rangeStart).to_i
        response.headers["Content-Range"]  = "bytes #{rangeStart}-#{rangeEnd == 0 ? "" : rangeEnd}/*"
      end
    end
    
end
