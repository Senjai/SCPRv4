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
  
  #---------------

  def feed
    if cache = Rails.cache.fetch("ext_program:#{program.slug}:podcast")
      render "/programs/feed/feed", title: "Recently", cache: cache

    elsif cache = Rails.cache.fetch("ext_program:#{program.slug}:rss")
      render "/programs/feed/feed", title: "Latest News", cache: cache

    else
      content_tag :span, "There is currently no feed available for this program.", class: "none-to-list"
    end
  end
  
  #---------------
  
  def web_url
    if program.web_url.blank?
      CONNECT_DEFAULTS[:web]
    else
      program.web_url
    end
  end

  #---------------
  
  def twitter_url
    if program.twitter_url.blank?
      CONNECT_DEFAULTS[:twitter]
    else
      if program.twitter_url =~ /twitter\.com/
        program.twitter_url
      else
        "http://twitter.com/#{program.twitter_url}"
      end
    end
  end
  
  #---------------
  
  def facebook_url
    if program.facebook_url.blank?
      CONNECT_DEFAULTS[:facebook]
    else
      program.facebook_url
    end
  end

  #---------------
  
  def rss_url
    if program.rss_url.blank?
      CONNECT_DEFAULTS[:rss]
    else
      program.rss_url
    end
  end

  #---------------

  def podcast_url
    if program.podcast_url.blank?
      CONNECT_DEFAULTS[:podcast]
    else
      program.podcast_url
    end
  end
end
