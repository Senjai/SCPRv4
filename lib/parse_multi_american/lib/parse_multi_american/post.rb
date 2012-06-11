module WP
  class Post
    DEFAULTS = {
      blog_id: WP::BLOG_ID,
      blog_slug: WP::BLOG_SLUG,
      is_published: 0
    }
    
    def initialize(attributes={})
      attributes.reverse_merge! DEFAULTS
    end
    
    def save
      b = ::BlogEntry.new(attributes)
      b.save
    end
  end
end
