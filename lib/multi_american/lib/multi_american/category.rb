module WP
  class Category < Node
    XPATH = "/rss/channel/wp:category"
    SCPR_CLASS = "BlogCategory"
    
    DEFAULTS = {
      blog_id: MultiAmerican::BLOG_ID
    }
    
    XML_AR_MAP = {
      # XML                 # AR
      category_nicename:    :slug,
      cat_name:             :title
    }
    
    administrate!
    self.list_fields = [
      ['id', title: "Term ID"],
      ['cat_name', link: true, title: "Name"],
      ['category_nicename', title: "Slug"]
    ]
    
    # -------------------
    # Class
    
    class << self

      # -------------------      
      # Elements
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
    end
    
    # -------------------
    # Instance
    
    def import
      object_builder = {}
      XML_AR_MAP.each do |wp_attr, ar_attr|
        object_builder.merge!(ar_attr => send(wp_attr))
      end
      
      object_builder.reverse_merge!(DEFAULTS)
      object = SCPR_CLASS.constantize.new(object_builder)
      
      object.save
    end
    
    # -------------------
    # Convenience Methods
    
    def id
      term_id
    end
    
    def to_title
      cat_name
    end
  end
end