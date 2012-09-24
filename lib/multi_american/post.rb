module MultiAmerican
  class Post < PostBase
    XPATH = "//item/wp:post_type[text()='post']/.."

    administrate do |admin|      
      admin.define_list do |list|
        list.column "id",         header: "WP-ID"
        list.column "post_type"
        list.column "title",      linked: true,   helper: :display_or_fallback
        list.column "post_name",  header: "Slug"
        list.column "pubDate"
        list.column "status"
      end
    end
        
    def style_rules!
      self.content = MultiAmerican.view.simple_format(self.content, {}, sanitize: false)
      super
    end
  end
end
