module Api::Public::V2
  class ScheduleSlotsController < BaseController

    before_filter \
      :sanitize_start_time, 
      :sanitize_length,
      only: [:index]

    before_filter :sanitize_time, only: [:show]

    #---------------------------
    
    def index
      @schedule_slots = ScheduleSlot.block(@start_time, @length)
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
      @start_time = begin
        if params[:start_time]
          Time.at(params[:start_time].to_i)
        else
          Time.now.beginning_of_week
        end
      end
    end

    def sanitize_length
      @length = params[:length] ? params[:length].to_i : 1.week
    end

    def sanitize_time
      @time = params[:time] ? Time.at(params[:time].to_i) : Time.now
    end
  end
end
