module WP
  class Author < Node
    XPATH = "/rss/channel/wp:author"

    administrate!    
    self.list_fields = [
      ['id', title: "Author ID"],
      ['author_display_name', link: true, title: "Name"],
      ['author_login'],
      ['author_email']
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
      author_id
    end
    
    def to_title
      author_display_name
    end
    
  end
end