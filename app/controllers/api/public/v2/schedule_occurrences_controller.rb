module Api::Public::V2
  class ScheduleOccurrencesController < BaseController

    MAXIMUM_LENGTH      = 1.week
    MAXIMUM_LOOKAHEAD   = 1.month

    DEFAULTS = {
      length: 1.week
    }

    before_filter \
      :sanitize_start_time,
      :sanitize_length,
      only: [:index]

    before_filter :sanitize_time, only: [:show]

    #---------------------------

    def index
      @schedule_slots = ScheduleOccurrence.block(@start_time, @length)
      respond_with @schedule_slots
    end

    #---------------------------

    def show
      @schedule_slot = Schedule.on_at(@time)

      if !@schedule_slot
        render_not_found and return false
      end

      respond_with @schedule_slot
    end

    #---------------------------

    private

    def sanitize_start_time
      if params[:start_time].present?
        @start_time = Time.at(params[:start_time].to_i)

        if @start_time > MAXIMUM_LOOKAHEAD.from_now
          render_bad_request(
            :message => "Can't determine schedule that far in the future."
          ) and return false
        end
      else
        @start_time = Time.now.beginning_of_week
      end
    end

    def sanitize_length
      if params[:length].present?
        length = params[:length].to_i
        @length = length > MAXIMUM_LENGTH ? length : MAXIMUM_LENGTH
      else
        @length = defaults[:length]
      end
    end

    def sanitize_time
      if params[:time].present?
        @time = Time.at(params[:time].to_i)

        if @time > MAXIMUM_LOOKAHEAD.from_now
          render_bad_request(
            :message => "Can't determine schedule that far in the future."
          ) and return false
        end
      else
        @time = Time.now
      end
    end
  end
end
