class ScheduleOccurrencePresenter < ApplicationPresenter
  presents :occurrence
  delegate \
    :title, 
    :public_url, 
    :is_distinct?, 
    :is_recurring?, 
    :program, 
    to: :occurrence


  def start_time
    format_time(occurrence.starts_at)
  end

  def end_time
    format_time(occurrence.ends_at)
  end


  def program_slug
    occurrence.program.slug if program
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
