class Api::BaseController < ApplicationController
  respond_to :json
  
  before_filter :set_access_control_headers

  #---------------------------
  
  def options
    head :ok
  end

  #---------------------------
  
  private
  
  #---------------------------
  
  def set_access_control_headers
    response.headers['Access-Control-Allow-Origin']      = request.env['HTTP_ORIGIN'] || "*"
    response.headers['Access-Control-Allow-Methods']     = 'GET, OPTIONS'
    response.headers['Access-Control-Max-Age']           = '1000'
    response.headers['Access-Control-Allow-Headers']     = 'x-requested-with,content-type,X-CSRF-Token'
    response.headers['Access-Control-Allow-Credentials'] = "true"
  end

  #---------------------------
    
  def sanitize_limit
    @limit = params[:limit] ? params[:limit].to_i : 10
  end

  #---------------------------
  
  def sanitize_page
    @page = params[:page] ? params[:page].to_i : 1
  end
  
  #---------------------------
  
  def sanitize_query
    @query = params[:query].to_s
  end
end
