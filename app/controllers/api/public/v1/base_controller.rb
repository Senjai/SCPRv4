module Api::Public::V1
  VERSION   = "1.0.0"
  TYPE      = "public"

  class BaseController < ::ActionController::Base
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
      response.headers['Access-Control-Allow-Methods']     = 'POST, GET, OPTIONS'
      response.headers['Access-Control-Max-Age']           = '1000'
      response.headers['Access-Control-Allow-Headers']     = 'x-requested-with,content-type,X-CSRF-Token'
      response.headers['Access-Control-Allow-Credentials'] = "true"
    end
  end
end
