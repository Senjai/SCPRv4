module WP
  class NavMenuItem < PostBase
    XPATH = "//item/wp:post_type[text()='nav_menu_item']/.."    
    self.list_fields = PostBase.list_fields
  end
end