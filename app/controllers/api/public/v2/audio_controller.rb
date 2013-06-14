module Api::Public::V2
  class AudioController < BaseController
    DEFAULTS = {
      :limit => 10,
      :page  => 1
    }

    MAX_RESULTS = 40
    
    before_filter \
      :sanitize_limit, 
      :sanitize_page,
      only: [:index]

    before_filter :sanitize_id, only: [:show]

    #---------------------------
    
    def index
      @audio = Audio.available.order("created_at desc").page(@page).per(@limit)
      respond_with @audio
    end
    
    #---------------------------
    
    def show
      @audio = Audio.available.where(id: @id).first

      if !@audio
        render_not_found and return false
      end
      
      respond_with @audio
    end

    #---------------------------

    private

    #---------------------------
    # Limit to 40 for public API
    def sanitize_limit
      if params[:limit].present?
        limit = params[:limit].to_i
        @limit = limit > MAX_RESULTS ? MAX_RESULTS : limit
      else
        @limit = DEFAULTS[:limit]
      end
    end

    #---------------------------
    
    def sanitize_page
      page = params[:page].to_i
      @page = page > 0 ? page : DEFAULTS[:page]
    end
    
    #---------------------------

    def sanitize_id
      @id = params[:id].to_i
    end
  end
end
