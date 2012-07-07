module WP
  class Roundup < Post
    XPATH = "//item/wp:post_type[text()='roundup']/.."
    CACHE_KEY = "roundups"
    
    self.list_fields = Post.list_fields
  end
end