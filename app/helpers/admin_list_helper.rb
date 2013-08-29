module AdminListHelper
  def display_link(link)
    link_to content_tag(:i, nil, class: "icon-share-alt"), link, class: "btn"
  end

  #-------------
  # Associations

  # For a polymorphic content association - requires headline and obj_key
  def display_content(content)
    if content && content.respond_to?(:headline) && content.respond_to?(:obj_key)
      s = content.headline
      s += " (" + link_to(content.obj_key, content.admin_edit_path) + ")"
      s.html_safe
    end
  end

  #-------------
  # Attribute Helpers

  def display_status(status)
    content_tag :div, ContentBase::STATUS_TEXT[status], class: status_bootstrap_map[status]
  end


  def display_air_status(air_status)
    KpccProgram::PROGRAM_STATUS[air_status]
  end

  def display_audio(audio)
    return audio if !audio.is_a? Array
    status = audio.first.try(:status)
    content_tag :div, Audio::STATUS_TEXT[status], class: audio_bootstrap_map[status]
  end

  #-------------
  # Maps

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
end
