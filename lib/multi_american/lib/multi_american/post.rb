module WP
  class Post < PostBase
    XPATH = "//item/wp:post_type[text()='post']/.."
    self.list_fields = PostBase.list_fields
  end
end
