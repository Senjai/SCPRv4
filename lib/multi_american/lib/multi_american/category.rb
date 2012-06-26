module WP
  class Category < Node
    XPATH = "/rss/channel/wp:category"
    
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