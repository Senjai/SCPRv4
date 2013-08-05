class ProgramPresenter < ApplicationPresenter
  presents :program
  delegate :title, :slug, :public_url, :public_path, to: :program


  def teaser
    program.teaser.try(:html_safe)
  end

  def description
    program.description.try(:html_safe)
  end

  def web_link
    if link = program.get_link("website")
      h.link_to "Website", link,
        :target => "_blank",
        :class  => "archive with-icon"
    end
  end

  def facebook_link
    if link = program.get_link("facebook")
      h.link_to "Facebook", link,
        :target => "_blank",
        :class  => "facebook with-icon"
    end
  end

  def podcast_link
    if link = program.podcast_url
      h.link_to "Podcast", link,
        :target => "_blank",
        :class  => "podcast with-icon"
    end
  end

  def rss_link
    if link = program.rss_url
      h.link_to "RSS", link,
        :target => "_blank",
        :class  => "rss with-icon"
    end
  end

  def twitter_link
    if program.twitter_handle.present?
      h.link_to "@#{program.twitter_handle}", 
        h.twitter_profile_url(program.twitter_handle),
        :target => "_blank",
        :class  => "twitter with-icon"
    end
  end
end
