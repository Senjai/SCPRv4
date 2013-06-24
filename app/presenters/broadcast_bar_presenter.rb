class BroadcastBarPresenter < ApplicationPresenter
  presents :slot
  delegate :title, :public_url, to: :slot

  def show_modal?
    !!program.try(:display_episodes)
  end

  def is_for_featured_program?
    !!program.try(:is_featured?)
  end


  def start_time
    format_time(slot.starts_at)
  end

  def end_time
    format_time(slot.ends_at)
  end


  def modal_class
    "modal-toggler" if show_modal?
  end

  def toggler_id
    "episode-guide" if show_modal?
  end

  def headshot_class
    "with-headshot" if program && is_for_featured_program?
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
