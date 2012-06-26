module WP
  class Author < Node
    XPATH = "/rss/channel/wp:author"
    
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
      author_id
    end
    
    def to_title
      author_display_name
    end
    
  end
end