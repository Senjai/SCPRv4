class ScheduleSlotPresenter < ApplicationPresenter
  presents :slot
  delegate :title, :public_url, to: :slot


  def start_time
    format_time(slot.starts_at)
  end

  def end_time
    format_time(slot.ends_at)
  end


  def program_slug
    slot.program.slug if program
  end

  def program
    slot.program if recurring?
  end


  def recurring?
    slot.is_a?(RecurringScheduleSlot)
  end

  def distinct?
    slot.is_a?(DistinctScheduleSlot)
  end


  private

  def format_time(time)
    str_time = time.strftime("%H:%M")

    if str_time == "00:00"
      "midnight"
    elsif str_time == "12:00"
      "noon"
    elsif str_time.match /:00/
      time.strftime("%l%P")
    else
      time.strftime("%l:%M%P")
    end
  end
end
