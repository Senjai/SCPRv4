module AdminListHelper
  
  # -- Used by index view -- #
  
  def render_attribute(item, record, options={})
    options[:path] ||= url_for([:edit, :admin, record])
    
    attrib         = record.send(item[0])
    attrib_options = item[1]
    display_helper = attrib_options[:display_helper]
    
    if !display_helper
      display_helper = "display_as_is"
      
      if record.class.respond_to?(:columns_hash) and record.class.columns_hash[item[0]]
        display_helper = "display_#{record.class.columns_hash[item[0]].type}"
      end
      
      if self.methods.include? "display_#{item[0]}".to_sym
        display_helper = "display_#{item[0]}"
      end
    end

    rendered_item = send(display_helper, attrib)
    
    if attrib_options[:link]
      rendered_item = link_to(rendered_item, options[:path])
    end
    
    return rendered_item  
  end
  
  
  
  # -- Custom Render methods -- #
    
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
  
  def display_as_is(attrib)
    attrib
  end
  
  #-------------
  # Attribute Helpers
  
  def display_status(status)
    content_tag :span, ContentBase::STATUS_TEXT[status], class: status_bootstrap_map[status]
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
  
  #-------------
  # Type helpers
  
  def display_datetime(datetime)
    format_date(datetime, format: :full_date, time: true)
  end
  
  def display_boolean(boolean)
    content_tag(
      :span, 
      content_tag(:i, "", class: boolean_bootstrap_map[!!boolean][:icon]), 
      class: boolean_bootstrap_map[!!boolean][:badge]
    )
  end
  
  
  #-------------
  # Maps
    
  def boolean_bootstrap_map
    {
      true  => { icon: "icon-white icon-ok",     badge: "badge badge-success"},
      false => { icon: "icon-white icon-remove", badge: "badge badge-important"}
    }
  end
  
  def status_bootstrap_map
    {
      ContentBase::STATUS_KILLED  => "label label-important",
      ContentBase::STATUS_DRAFT   => "label",
      ContentBase::STATUS_REWORK  => "label label-info",
      ContentBase::STATUS_EDIT    => "label label-inverse",
      ContentBase::STATUS_PENDING => "label label-warning",
      ContentBase::STATUS_LIVE    => "label label-success"
    }
  end
  
  # If we just want the helper to return the value,
  # it will fall back to this
  def method_missing(method, *args, &block)
    if method =~ /^display_/
      return args.first
    end
    super
  end  
end
