class BlogPresenter < ApplicationPresenter
  presents :blog
  delegate :name, to: :blog


  def facebook_link
    if link = blog.get_link("facebook")
      h.link_to "Facebook", link,
        :target => "_blank",
        :class  => "facebook with-icon"
    end
  end

  def rss_link
    if link = blog.get_link("rss")
      h.link_to "RSS", link,
        :target => "_blank",
        :class  => "rss with-icon"
    end
  end

  def twitter_link
    if blog.twitter_handle.present?
      h.link_to "@#{blog.twitter_handle}", 
        h.twitter_profile_url(blog.twitter_handle),
        :target => "_blank",
        :class  => "twitter with-icon"
    end
  end
end
