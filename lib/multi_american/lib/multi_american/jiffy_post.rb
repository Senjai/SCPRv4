module WP
  class JiffyPost < Post
    XPATH = "//item/wp:post_type[text()='jiffypost']/.."
    
    AR_XML_MAP = {
      title:              "title",
      slug:               "post_name",
      content:            "content_encoded",
      author_id:          "author_id",
      blog_id:            "blog_id",
      blog_slug:          "blog_slug",
      published_at:       "pubDate",
      is_published:       "is_published",
      status:             "status",
      blog_asset_scheme:  "blog_asset_scheme",
      comment_count:      "comment_count",
      _short_headline:    "short_headline",
      _teaser:            "excerpt_encoded",
      wp_id:              "post_id"
    }

    class << self
      def find(doc)
        new_records = []
      
        doc.xpath(XPATH).reject { |i| invalid_item(i) }.each do |element|
          builder = { categories: [], post_meta: [] }
          
          element.children.reject { |c| invalid_child(c) }.each do |child|
            if child.name == "category"
              category = {  title: child.content, 
                            domain: child[:domain], 
                            nicename: child[:nicename] }
              builder[:categories].push category
            
            elsif child.name == "postmeta"
              postmeta = {  meta_key: child.at_xpath("./wp:meta_key").content, 
                            meta_value: child.at_xpath("./wp:meta_value").content }
              builder[:post_meta].push postmeta

            elsif child.namespace.present? && !%w{ wp }.include?(child.namespace.prefix)
              builder.merge!(child.namespace.prefix => child.children.first.content)
            else
              builder.merge!(child.name.gsub(/\W/, "_") => child.content)
            end

          end
          new_records.push self.new(builder)
        end
        
        new_records
      end
      
      
      def invalid_child(node)
        %w{text comment}.include?(node.name)
        
      end
      
      def invalid_item(node)
        node.at_xpath("./wp:status").content != "publish"
      end
    end
  end
end
