module Api::Private::V2
  VERSION   = "2.0.0"
  TYPE      = "private"

  class BaseController < ::ActionController::Base
    respond_to :json
    
    before_filter :set_access_control_headers, :authorize

    #---------------------------
    
    def options
      head :ok
    end

    #---------------------------
    
    private
    
    def authorize
      if params[:token] != Rails.application.config.api['assethost']['token']
        render json: { error: "Unauthorized" }, status: :unauthorized
        return false
      end
    end

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
