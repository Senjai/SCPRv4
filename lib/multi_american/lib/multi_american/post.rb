module WP
  class Post < Node
    SCPR_CLASS = "BlogEntry"
    CONTENT_TYPE_ID = 44 # BlogEntry (in mercer)
    
    XPATH = "//item/wp:post_type[text()='post']/.."
    
    DEFAULTS = {
      blog_id:      MultiAmerican::BLOG_ID,
      blog_slug:    MultiAmerican::BLOG_SLUG,
      is_published: 0 # otherwise mercer cries
    }
    
    AR_XML_MAP = {
      title:              "title",
      slug:               "post_name",
      content:            "content_encoded",
      author_id:          "author_id",
      blog_id:            "blog_id",
      blog_slug:          "blog_slug",
      published_at:       "pubDate",
      is_published:       "is_published",
      status:             "status",
      blog_asset_scheme:  "blog_asset_scheme",
      comment_count:      "comment_count",
      _short_headline:    "short_headline",
      _teaser:            "excerpt_encoded",
      wp_id:              "post_id"
    }
    
    administrate!    
    self.list_fields = [
      ['id', title: "WP-ID"],
      ['post_type'],
      ['title', link: true, display_helper: :display_or_fallback],
      ['post_name', title: "Slug"],
      ['pubDate'],
      ['status']
    ]

    # -------------------
    # Class
    
    class << self

      # -------------------      
      # Elements
      
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
      
      
      # -------------------      
      # Node rejectors
      
      def invalid_child(node)
        %w{text comment}.include?(node.name)
      end
      
      def invalid_item(node)
        # Only published content
        node.at_xpath("./wp:status").content != "publish"
      end
      
      # -------------------      
      
      def nested_attributes
        [:@categories, :@postmeta]
      end
    end
    

    # -------------------
    # Instance
    
    def initialize(element)
      @builder = { categories: [], postmeta: [] }
      super(element)
    end
    
    def sorter
      Time.parse(self.pubDate)
    end
    
    
    # -------------------
    # Builder populator
    
    def check_and_merge_nodes(child)
      if is_category(child)
        merge_category(child)
      else
        super
      end
    end
    
    
    # -------------------      
    # Merge in extra attributes
    
    def merge_category(child)
      category = {  title: child.content, 
                    domain: child[:domain], 
                    nicename: child[:nicename] }
      builder[:categories].push category
    end
    
    
    # -------------------
    # Node inspectors
    
    def is_category(child)
      child.name == "category"
    end
    
    
    # -------------------    

    def build_for_scpr
      builder = {}
      XML_AR_MAP.each do |scpr_a, wp_a|
        builder.merge!(scpr_a => send(wp_a))
      end
      
      instance_variable_set("@#{SCPR_CLASS.underscore}", SCPR_CLASS.constantize.new(builder))
    end
    
    
    # -------------------
    # Convenience Methods
    
    def to_title
      title
    end
    
    def id
      post_id
    end
    
    def status=(value)
      status_map = {
        "publish" => 5,
        "inherit" => 5,
        "draft"   => 0
      }
      
      @status = status_map[value]
    end
  end
end
