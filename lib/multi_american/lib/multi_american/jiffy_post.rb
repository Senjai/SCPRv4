module WP
  class JiffyPost < Post
    XPATH = "//item/wp:post_type[text()='jiffypost']/.."    
    CACHE_KEY = "jiffy_posts"
  
    self.list_fields = Post.list_fields
  end
end
