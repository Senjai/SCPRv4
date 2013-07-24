class ProgramPresenter < ApplicationPresenter
  presents :program
  delegate :title, :slug, to: :program


  def teaser
    if program.teaser.present?
      program.teaser.html_safe
    end
  end

  def description
    if program.description.present?
      program.description.html_safe
    end
  end

  def web_link
    if link = program.get_url("website")
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
    if link = program.get_link("podcast")
      h.link_to "Podcast", link,
        :target => "_blank",
        :class  => "podcast with-icon"
    end
  end

  def rss_link
    if link = program.get_link("rss")
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
