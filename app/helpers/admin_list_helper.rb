module AdminListHelper
  
  # -- Used by index view -- #
  
  def render_attribute(item, record)
    attrib = record.send(item[0])
    options = item[1]
    rendered_item = send(options[:display_helper], attrib)
    
    if options[:link]
      rendered_item = link_to(rendered_item, url_for([:edit, :admin, record]))
    end
    
    return rendered_item  
  end
  
  
  
  # -- Custom Render methods -- #
  
  def display_audio(audio)
    return audio if !audio.is_a? Audio
    
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