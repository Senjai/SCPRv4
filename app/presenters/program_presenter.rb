class ProgramPresenter < ApplicationPresenter
  presents :program
  delegate :title, :slug, to: :program
  
  def teaser
    if program.teaser.present?
     program.teaser.html_safe
    end
  end
  
  #---------------
    
  def twitter_url
    if program.twitter_url.present?
      if program.twitter_url =~ /twitter\.com/
        program.twitter_url
      else
        "http://twitter.com/#{program.twitter_url}"
      end
    else
      CONNECT_DEFAULTS[:twitter]
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
