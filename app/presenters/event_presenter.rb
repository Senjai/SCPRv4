class EventPresenter < ApplicationPresenter
  presents :event
  delegate :headline, :link_path, to: :event
  
  #-------------
  
  def description
    if event.upcoming? or event.archive_description.blank?
      s = event.body
    else
      s = event.archive_description
    end
    
    s.html_safe
  end

  #-------------
  
  def sponsor
    if event.sponsor.present?
      h.content_tag :p, class: "sponsor" do
        s = "Sponsor: " 
        if event.sponsor_link?
          s += h.link_to event.sponsor, event.sponsor_link
        else
          s += event.sponsor
        end
        
        s.html_safe
      end
    end
  end

  #-------------
  
  def date
    if event.upcoming? or event.current?
      h.content_tag :div, range_date, class: "upcoming-date"
    else 
      h.content_tag :div, class: "past-date" do
        "This event took place on:<br />#{range_date}".html_safe
      end
    end    
  end

  #-------------
  
  def rsvp_link
    if event.rsvp_link.present? && event.upcoming?
      h.link_to "RSVP for this event", event.rsvp_link, class: "btn primary", id: "events-rsvp-btn"
    end
  end

  #-------------
  
  def location_name
    if event.location_link.present?
      h.link_to event.location_name, event.location_link
    else
      event.location_name
    end
  end

  #-------------

  def address
    s, l = "".html_safe, "".html_safe
    s += h.content_tag(:li, event.address_1) if event.address_1.present?
    s += h.content_tag(:li, event.address_2) if event.address_2.present?
    s += h.content_tag :li do
      if event.city.present?
        l += "#{event.city}"
        l += ", " if event.state.present? || event.zip_code.present?
      end
      if event.state.present?
        l += event.state
        l += " " if event.zip_code.present?
      end
      l += event.zip_code
    end if event.city.present? || event.state.present? || event.zip_code.present?
    
    s
  end

  #-------------
  
  def map
    if event.show_map && (event.upcoming? || event.current?)
      h.render '/events/map/map', p: self
    end
  end
  
  #-------------
  
  def range_date
    st = event.starts_at
    en = event.ends_at

    # If one needs minutes, use that format for the other as well, for consistency    
    timef = "%-l"
    timef += ":%M" unless (st.min == 0 and [0, nil].include?(en.try(:min)))
    datef = "%A, %B %-e"

    s = ""
    
    if event.is_all_day?
      s += st.strftime(datef)
      s += en.strftime(" - #{datef}") if en.present?
      
    elsif en.blank?
      s += st.strftime("#{datef}, #{timef}%P")

    elsif st.day == en.day
      # If the event starts and ends on the same day
      p = (st.strftime("%P") != en.strftime("%P")) ? "%P" : ""
      s += st.strftime("#{datef}, #{timef}#{p} - ") 
      s += en.strftime("#{timef}%P")
    
    else
      # If the event starts and ends on different days
      s += st.strftime("#{datef}, #{timef}%P - ") 
      s += en.strftime("#{datef}, #{timef}%P")
    end
    
    s
  end

  #-------------
  
  def inline_address
    [ event.address_1, 
      event.address_2, 
      event.city, 
      event.state, 
      event.zip_code
    ].reject { |element| element.blank? }.join(", ")
  end
end
