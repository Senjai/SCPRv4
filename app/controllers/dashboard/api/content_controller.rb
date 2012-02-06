class Dashboard::Api::ContentController < ApplicationController
  
  before_filter :require_admin
  before_filter :set_access_control_headers
  
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
  
  def by_url
    content = ContentBase.obj_by_url(params[:id])
    
    if content
      render :json => content.as_json
    else
      render :text => "Not Found", :status => :not_found
    end
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