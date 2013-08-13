module Api::Public::V3
  VERSION   = Gem::Version.new("3.0.0")
  TYPE      = "public"

  class BaseController < ::ActionController::Base
    respond_to :json

    before_filter :set_access_control_headers

    #---------------------------

    def options
      head :ok
    end

    #---------------------------

    def api_view_path(resource, filename)
      File.join("api", TYPE, "v#{VERSION.segments[0]}", resource, filename)
    end
    helper_method :api_view_path


    private

    def sanitize_id
      @id = params[:id].to_i
    end

    # ID is actually the slug.
    # Rails' routing "resources" method automatically
    # names the id parameter to :id, but we're expecting
    # a string (the slug). It's being renamed to :slug for
    # the variable because "id" is usually an integer, and
    # we don't want to get confused.
    def sanitize_slug
      @slug = params[:id].to_s
    end

    def sanitize_limit
      if params[:limit].present?
        limit = params[:limit].to_i
        @limit = limit > max_results ? max_results : limit
      else
        @limit = defaults[:limit]
      end
    end

    def sanitize_page
      page = params[:page].to_i
      @page = page > 0 ? page : defaults[:page]
    end

    #---------------------------

    def max_results
      self.class::MAX_RESULTS
    end

    def defaults
      self.class::DEFAULTS
    end

    #---------------------------

    def set_access_control_headers
      response.headers['Access-Control-Allow-Origin']      = request.env['HTTP_ORIGIN'] || "*"
      response.headers['Access-Control-Allow-Methods']     = 'POST, GET, OPTIONS'
      response.headers['Access-Control-Max-Age']           = '1000'
      response.headers['Access-Control-Allow-Headers']     = 'x-requested-with,content-type,X-CSRF-Token'
      response.headers['Access-Control-Allow-Credentials'] = "true"
    end

    #---------------------------

    def render_not_found(options={})
      message = options[:message] || "Not Found"
      render status: :not_found, json: { error: message }
    end

    #---------------------------

    def render_bad_request(options={})
      message = options[:message] || "Bad Request"
      render status: :bad_request, json: { error: message }
    end

    #---------------------------

    def render_unauthorized(options={})
      message = options[:message] || "Unauthorized"
      render status: :unauthorized, json: { error: message }
    end

    #---------------------------

    def render_service_unavailable(options={})
      message = options[:message] || "Service Unavailable"
      render status: :service_unavailable, json: { error: message }
    end
  end
end
