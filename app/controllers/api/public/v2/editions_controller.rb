module Api::Public::V2
  class EditionsController < BaseController
    before_filter(
      :sanitize_limit, 
      :sanitize_page,
      only: [:index]
    )

    before_filter :sanitize_id, only: [:show]

    #---------------------------
    
    def index
      @editions = Edition.includes(:slots).published.page(@page).per(@limit)
      respond_with @editions
    end
    
    #---------------------------
    
    def show
      @edition = Edition.includes(:slots).published.where(id: @id).first

      if !@edition
        render_not_found and return false
      end
      
      respond_with @edition
    end

    #---------------------------

    private

    #---------------------------
    # Limit to 10 for public API
    def sanitize_limit
      if params[:limit].present?
        limit = params[:limit].to_i
        @limit = limit > 4 ? 4 : limit
      else
        @limit = 2
      end
    end

    #---------------------------
    
    def sanitize_page
      page = params[:page].to_i
      @page = page > 0 ? page : 1
    end
    
    #---------------------------

    def sanitize_id
      @id = params[:id].to_i
    end
  end
end
