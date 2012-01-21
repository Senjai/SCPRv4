class NewsController < ApplicationController
  layout "news"

  def index
    # build list of news categories    
    @content = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => params[:page] || 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with => { :category => Category.where(:is_news => true).all.map { |c| c.id } }
    )
    
    render :layout => "application"
    
  end
  
  #----------
  
  def arts
    # build list of news categories    
    @content = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => params[:page] || 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with => { :category => Category.where(:is_news => false).all.map { |c| c.id } }
    )
    
    render :layout => "application"    
  end
  
  #----------

  def story
    begin
      @story = NewsStory.published.find(params[:id])
    rescue
      # if this story doesn't exist or hasn't been published, send them to the home page
      redirect_to home_path and return
    end
    
    
    #Rails.logger.debug "PATH_INFO is #{request.env['PATH_INFO']}"
    
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @story.link_path
      redirect_to @story.link_path and return
    end
    
    # otherwise, just render
  end
end
