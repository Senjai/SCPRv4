module WP
  class Post
    DEFAULTS = {
      blog_id: WP::BLOG_ID,
      blog_slug: WP::BLOG_SLUG,
      is_published: 0
    }
    
    METHODS = {
      post_id: 'wp_id',
      pubDate: "published_at",
      title: "title",
      "content:encoded" => "content",
      "excerpt:encoded" => "teaser",
      status: "status",
      post_name: "slug",
      post_type: "post_type"
    }

    class << self
      def filter_values(key, value)
        { METHODS[key].to_sym => send(METHODS[key], value) }
      end
      
      def wp_id(value)
        value
      end
      
      def title(value)
        value
      end
      
      def published_at(value)
        value
      end
      
      def content(value)
        Parser.strip_cdata(value)
      end
      
      def teaser(value)
        Parser.strip_cdata(value)
      end
      
      def status(value)
        value == "publish" ? 5 : 0
      end
      
      def slug(value)
        value
      end
      
      def post_type(value)
        value
      end
    end
  end
end
