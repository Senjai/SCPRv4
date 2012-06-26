module WP
  class NavMenuItem < Post
    XPATH = "//item/wp:post_type[text()='nav_menu_item']/.."
    self.list_fields = Post.list_fields
    
    class << self
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
    end
  end
end