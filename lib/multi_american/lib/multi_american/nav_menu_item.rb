module WP
  class NavMenuItem < PostBase
    XPATH = "//item/wp:post_type[text()='nav_menu_item']/.."    
    self.list_fields = PostBase.list_fields
    
    def style_rules!
      self.content = WP.view.simple_format(self.content, {}, sanitize: false)
      super
    end
  end
end