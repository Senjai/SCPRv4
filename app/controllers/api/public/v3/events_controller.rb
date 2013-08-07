module Api::Public::V3
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
      :sanitize_only_kpcc_events,
      :sanitize_types,
      :sanitize_date_range,
      only: [:index]

    before_filter :sanitize_id, only: [:show]

    #---------------------------
    
    def index
      @events = Event.published.order("starts_at").page(@page).per(@limit)
      
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

    def sanitize_date_range
      begin
        start_date = params[:start_date] ? Time.parse(params[:start_date]) : nil
        end_date   = params[:end_date] ? Time.parse(params[:end_date]) : nil
      rescue ArgumentError # Time couldn't be parsed
        render_bad_request(message: "Invalid Date. Format is YYYY-MM-DD.")
        return false
      end

      @conditions.push(["starts_at >= ?", start_date]) if start_date
      @conditions.push(["starts_at < ?", end_date])    if end_date

      # If we requested an end date in the future, then
      # it likely means that someone is looking for
      # a list of events between now and then. In that 
      # case, add a condition to filter start_date
      # by Time.now. However, if an end_date was 
      # requested in the past, then it probably
      # means that they are listing archived
      # events, so in that case we will let it go to
      # the beginning of time.
      #
      # We also want to add this condition if no end_date
      # is specified, because at this point is means
      # that no dates were specified, so we just assume
      # they want Now until forever.
      if !start_date && ( !end_date || end_date > Time.now )
        @conditions.push(["starts_at >= ?", Time.now])
      end
    end

    def sanitize_only_kpcc_events
      if params[:only_kpcc_events] == "true"
        @conditions.push(is_kpcc_event: true)
      end
    end

    def sanitize_types
      if params[:types]
        types = params[:types].split(",") & Event::EVENT_TYPES.keys
        @conditions.push(event_type: types)
      end
    end
  end
end
