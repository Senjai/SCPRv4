module WP
  class Post
    SCPR_CLASS = "BlogEntry"
    XPATH = "//item/wp:post_type[text()='post']/.."
    NESTED_ATTRIBUTES = [:@categories, :@post_meta] # For the views
    
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
      def elements(doc)
        doc.xpath(XPATH)
      end

      # -------------------
      
      def find(doc)
        new_records = []
      
        elements(doc).reject { |i| invalid_item(i) }.each do |element|
          new_records.push build_object(element)
        end
        
        new_records
      end
      
      # -------------------
      
      def build_object(element)
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
        
        # Return a new object
        self.new(builder)
      end

      # -------------------      
      
      def invalid_child(node)
        %w{text comment}.include?(node.name)
        
      end
      
      def invalid_item(node)
        node.at_xpath("./wp:status").content != "publish"
      end
    end
    
    # -------------------
    
    def initialize(attributes={})
      attributes.each { |a, v| send("#{a}=", v) }
    end
    
    # Dynammic accessor
    def method_missing(method, *args, &block)
      if method =~ /=$/
        return instance_variable_set("@#{method.to_s.chomp("=")}", args.first)
      else
        return instance_variable_get("@#{method}")
      end
    end
    
    # -------------------
    
    def build_for_scpr
      builder = {}
      XML_AR_MAP.each do |scpr_a, wp_a|
        builder.merge!(scpr_a => send(wp_a))
      end
      
      instance_variable_set("@#{SCPR_CLASS.underscore}", SCPR_CLASS.constantize.new(builder))
    end
    
    def status=(value)
      @status = value == "publish" ? 5 : 0
    end
  end
end
