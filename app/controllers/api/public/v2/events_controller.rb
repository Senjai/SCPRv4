module Api::Public::V2
  class EventsController < BaseController
    before_filter \
      :sanitize_limit,
      :sanitize_page,
      only: [:index]

    before_filter :sanitize_id, only: [:show]

    #---------------------------
    
    def index
      @events = Event.order("created_at desc").page(@page).per(@limit)
      respond_with @events
    end
    
    #---------------------------
    
    def show
      @event = Event.where(id: @id).first

      if !@event
        render_not_found and return false
      end
      
      respond_with @event
    end

    #---------------------------

    private

    #---------------------------
    # Limit to 40 for public API
    def sanitize_limit
      if params[:limit].present?
        limit = params[:limit].to_i
        @limit = limit > 40 ? 40 : limit
      else
        @limit = 10
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
