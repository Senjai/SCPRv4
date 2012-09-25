module AdminListHelper
  
  # -- Used by index view -- #
  
  def render_attribute(column, record, options={})
    options[:path] ||= url_for([:edit, :admin, record])
    
    attrib         = record.send(column.attribute)
    display_helper = column.helper
    
    # If no helper was specified, try some defaults
    # More specific helpers are favored
    if !display_helper
      
      # Just return the value
      display_helper = "display_as_is"
      
      # If it's an AR model and the attribute is a column,
      # we can use display_#{type}
      if record.class.respond_to?(:columns_hash) and record.class.columns_hash[column.attribute]
        display_helper = "display_#{record.class.columns_hash[column.attribute].type}"
      end
      
      # If it's an AR model and the attribute is an AssociationReflection,
      # we can use display_association
      if record.class.respond_to?(:reflect_on_association) and record.class.reflect_on_association(column.attribute.to_sym)
        display_helper = "display_association"
      end
      
      # If this helper module defines display_#{attribute}, we should use that
      if self.methods.include? "display_#{column.attribute}".to_sym
        display_helper = "display_#{column.attribute}"
      end
    end

    if !display_helper.is_a? Proc
      rendered_item = send(display_helper, attrib)
    else
      rendered_item = display_helper.call(attrib)
    end
    
    if column.linked?
      rendered_item = link_to(rendered_item, options[:path])
    end
    
    return rendered_item  
  end
  
  
  
  # -- Custom Render methods -- #
  
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
  
  def display_association(attrib)
    attrib.to_title
  end
  
  def display_status(status)
    content_tag :div, ContentBase::STATUS_TEXT[status], class: status_bootstrap_map[status]
  end
  
  def display_bylines(bylines)
    if bylines.present?
      bylines.first.user.try(:name) || bylines.first.name
    end
  end
  
  def display_air_status(air_status)
    KpccProgram::PROGRAM_STATUS[air_status]
  end
  
  def display_audio(audio)
    return audio if !audio.is_a? Array
    content_tag :div, Audio::STATUS_TEXT[audio.first.try(:status)], class: audio_bootstrap_map[audio.first.try(:status)]
  end
  
  #-------------
  # Type helpers
  
  def display_datetime(datetime)
    format_date(datetime, format: :full_date, time: true)
  end
  
  def display_boolean(boolean)
    content_tag(:span, 
      content_tag(:i, "", class: boolean_bootstrap_map[!!boolean][:icon]), 
      class: boolean_bootstrap_map[!!boolean][:badge])
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
      ContentBase::STATUS_KILLED  => "list-status label label-important",
      ContentBase::STATUS_DRAFT   => "list-status label",
      ContentBase::STATUS_REWORK  => "list-status label label-info",
      ContentBase::STATUS_EDIT    => "list-status label label-inverse",
      ContentBase::STATUS_PENDING => "list-status label label-warning",
      ContentBase::STATUS_LIVE    => "list-status label label-success"
    }
  end
  
  def audio_bootstrap_map
    {
      nil                => "list-status label",
      Audio::STATUS_WAIT => "list-status label label-warning",
      Audio::STATUS_LIVE => "list-status label label-success"
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
