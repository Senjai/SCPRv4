module AdminListHelper
  
  # -- Used by index view -- #
  
  def render_attribute(item, record, options={})
    options[:path] ||= url_for([:edit, :admin, record])
    
    attrib = record.send(item[0])
    attrib_options = item[1]
    rendered_item = send(attrib_options[:display_helper], attrib)
    
    if attrib_options[:link]
      rendered_item = link_to(rendered_item, options[:path])
    end
    
    return rendered_item  
  end
  
  
  
  # -- Custom Render methods -- #
  
  def display_audio(audio)
    return audio if !audio.is_a? Array
    
    if audio = audio.first
      if audio.mp3.present?
        "Live"
      elsif audio.enco_number.present? && audio.enco_date.present?
        "Awaiting ENCO"
      end
    else
      "None"
    end
  end
  
  def display_status(status)
    ContentBase::STATUS_TEXT[status]
  end
  
  def display_published_at(published_at)
    format_date(published_at, format: :full_date, time: true)
  end
  
  # for MultiAmerican
  def display_pubDate(pubDate)
    format_date(Time.parse(pubDate), time: true)
  end
  
  def display_date(date)
    format_date(date, format: :full_date)
  end
  
  
  def display_or_fallback(attrib)
    attrib.present? ? attrib : content_tag(:em, "[blank]")
  end
  
  def display_show(show)
    show.title
  end
  
  def display_blog(blog)
    blog.name
  end
  
  
  def display_bylines(bylines)
    if bylines.present?
      bylines.first.user.try(:name) || bylines.first.name
    end
  end
  
  def display_boolean(boolean)
    boolean ? "YES" : "NO"
  end
  
  # If we just want the helper to return the attribute,
  # it will fall back to this
  def method_missing(method, *args, &block)
    if method =~ /^display_/
      return args.first
    end
    super
  end
  
end