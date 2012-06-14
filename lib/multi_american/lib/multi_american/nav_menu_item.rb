module WP
    class NavMenuItem < Post
      XPATH = "//item/wp:post_type[text()='nav_menu_item']/.."
    end
end