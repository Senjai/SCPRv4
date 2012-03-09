class Dashboard::Api::ContentController < ApplicationController
  include ApplicationHelper
  
  before_filter :require_admin
  before_filter :set_access_control_headers
  skip_before_filter :verify_authenticity_token, :only=>[:preview]
  
  def options
    head :ok
  end
  
  #----------
  
  def index
    contents = []
    
    [params[:ids]].flatten.each do |id|
        contents << ContentBase.obj_by_key(id) || {}
    end
    
    render :json => contents.as_json
  end
  
  #----------
  
  def show
    # is this valid content?
    content = ContentBase.obj_by_key(params[:id])
    
    if content
      render :json => content.as_json
    else
      render :text => "Not Found", :status => :not_found
    end
  end
  
  #----------
  
  def preview
    # is this valid content?
    @content = ContentBase.obj_by_key(params[:id])
    
    [:headline, :_short_headline, :_teaser, :body, :content].each do |f|
      if params[ f ]
        @content[ f ] = params[ f ]
      end
    end
    
    if @content
      render "preview.js", :status => 200
    else
      render :text => "Not Found", :status => :not_found      
    end
  end
  
  #----------
  
  def by_url
    content = ContentBase.obj_by_url(params[:id])
    
    if content
      render :json => content.as_json
    else
      render :text => "Not Found", :status => :not_found
    end
  end
  
  #----------
  
  def recent
    #response.headers["Content-Type"] = 'text/xml'

    # check if we have a cached podcast.  If so, short-circuit and return it
    if cache = Rails.cache.fetch("cbaseapi:recent")
      render :json => cache, :formats => [:xml] and return
    end
    
    # nope -- build a new cache
    
    contents = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => 1,
      :per_page   => 20,
      :order      => :published_at,
      :sort_mode  => :desc,
    )
        
    json = contents.to_json
    Rails.cache.write_entry("cbaseapi:recent", json,:objects => [contents,"contentbase:new"].flatten)
    render :json => json
    
  end
  
  #----------
  
  private
  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN'] || "*"
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = '1000'
    headers['Access-Control-Allow-Headers'] = 'x-requested-with,content-type,X-CSRF-Token'
    headers['Access-Control-Allow-Credentials'] = "true"
  end
  
end