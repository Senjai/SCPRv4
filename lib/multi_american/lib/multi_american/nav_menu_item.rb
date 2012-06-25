module WP
  class NavMenuItem < Post
    XPATH = "//item/wp:post_type[text()='nav_menu_item']/.."
    
    class << self
      def elements(doc)
        doc.xpath(XPATH)
      end
    end
  end
end