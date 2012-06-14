module WP
  class Topic < Post
    XPATH = "//item/wp:post_type[text()='topic']/.."
  end
end