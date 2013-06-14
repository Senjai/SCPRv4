module Api::Public::V2
  class EventsController < BaseController
    DEFAULTS = {
      :limit => 40,
      :page  => 1
    }

    MAX_RESULTS = 40

    before_filter \
      :set_conditions,
      :sanitize_limit,
      :sanitize_page,
      :sanitize_date_range,
      only: [:index]

    before_filter :sanitize_id, only: [:show]

    #---------------------------
    
    def index
      @events = Event.order("starts_at").page(@page).per(@limit)
      
      @conditions.each do |condition|
        @events = @events.where(condition)
      end
      
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

    def set_conditions
      @conditions = []
    end

    def sanitize_date
      begin
        start_date = \
          params[:start_date] ? Time.parse(params[:start_date]) : Time.now

        @conditions << ["start_date => ?", start_date]

        if params[:end_date]
          @conditions << ["end_date < ?", Time.parse(params[:end_date])]
        end

      rescue ArgumentError # Time couldn't be parsed
        render_bad_request(message: "Invalid Date. Format is YYYY-MM-DD.") and return false
      end
    end

    #---------------------------
    # Limit to 40 for public API
    def sanitize_limit
      if params[:limit].present?
        limit = params[:limit].to_i
        @limit = limit > MAX_RESULTS ? MAX_RESULTS : limit
      else
        @limit = 10
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
