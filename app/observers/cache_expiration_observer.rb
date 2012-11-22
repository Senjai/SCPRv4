##
# CacheExpirationObserver
#
# Watches classes, expires cache.
#
class CacheExpirationObserver < ActiveRecord::Observer
  observe NewsStory, BlogEntry, ShowSegment, ShowEpisode, ContentShell, VideoShell
  
  def after_save(content)
    # If we are going from published -> published (still),
    # or we are going from published -> unpublished,
    # just expire this object
    if (content.published? and !content.publishing?) or content.unpublishing?
      Rails.cache.expire_obj(content.obj_key)
    end
    
    # If we are going from not published -> published.
    # Expire :new keys for the object's class
    if content.publishing?
      Rails.cache.expire_obj([content.class.content_key, "new"].join "/")
      Rails.cache.expire_obj("contentbase:new")
    end
    
    # TODO: Redis publish
    # Publisher.publish_content(content, "publish")
  end
end