module WP
  class NavMenuItem < Post
    XPATH = "//item/wp:post_type[text()='nav_menu_item']/.."
    CACHE_KEY = "nav_menu_items"
    
    self.list_fields = Post.list_fields
    
    class << self
      def elements(doc)
        doc.xpath(XPATH)
      end
    end
  end
end