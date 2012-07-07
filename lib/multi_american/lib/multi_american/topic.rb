module WP
  class Topic < Post
    XPATH = "//item/wp:post_type[text()='topic']/.."
    CACHE_KEY = "topics"

    self.list_fields = Post.list_fields
  end
end
