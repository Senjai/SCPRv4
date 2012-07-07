module WP
  class NavMenuItem < Post
    XPATH = "//item/wp:post_type[text()='nav_menu_item']/.."
    CACHE_KEY = "nav_menu_items"
    
    self.list_fields = Post.list_fields
  end
end