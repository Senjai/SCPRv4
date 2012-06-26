module WP
  class Tag < Node
    XPATH = "/rss/channel/wp:tag"

    administrate!    
    self.list_fields = [
      ['id', title: "Term ID"],
      ['tag_slug', link: true, title: "Name"],
      ['tag_name']
    ]
    self.list_per_page = 50
    
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
      tag_name
    end
  end
end