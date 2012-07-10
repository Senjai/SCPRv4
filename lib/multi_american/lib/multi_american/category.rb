module WP
  class Category < Node
    XPATH = "/rss/channel/wp:category"
    SCPR_CLASS = "BlogCategory"
    CACHE_KEY = "categories"
    
    DEFAULTS = {
      blog_id: MultiAmerican::BLOG_ID
    }
    
    XML_AR_MAP = {
      # XML                 # AR
      category_nicename:    :slug, # Primary
      id:                   :wp_id,
      cat_name:             :title
    }
    
    # What's stored under the Post item
    # vs. what's stored in the Category item
    RAW_REAL_MAP = { 
      nicename: :category_nicename,
      title:    :cat_name
    }
    
    class << self
      def raw_real_map
        self::RAW_REAL_MAP
      end
    end
    
    administrate!
    self.list_fields = [
      ['id', title: "Term ID"],
      ['cat_name', link: true, title: "Name"],
      ['category_nicename', title: "Slug"]
    ]
    
    # -------------------
    # Instance
    
    # -------------------
    # Convenience Methods
    
    def id
      term_id.to_i
    end
    
    def to_title
      cat_name
    end
  end
end