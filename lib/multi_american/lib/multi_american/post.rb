module WP
  class Post < Node
    SCPR_CLASS = "BlogEntry"
    CONTENT_TYPE_ID = 44 # BlogEntry (in mercer)
    
    XPATH = "//item/wp:post_type[text()='post']/.."
    
    DEFAULTS = {
      blog_id: MultiAmerican::BLOG_ID,
      blog_slug: MultiAmerican::BLOG_SLUG,
      author_id: MultiAmerican::AUTHOR_ID,
      is_published: 0,
      blog_asset_scheme: "",
      comment_count: 0
    }
    
    XML_AR_MAP = {
      id:                 :wp_id,
      post_name:          :slug,
      title:              :title,
      content:            :content,
      pubDate:            :published_at,
      status:             :status,
      excerpt:            :_teaser
    }
    
    administrate!    
    self.list_fields = [
      ['id', title: "WP-ID"],
      ['post_type'],
      ['title', link: true, display_helper: :display_or_fallback],
      ['post_name', title: "Slug"],
      ['pubDate'],
      ['status']
    ]

    # -------------------
    # Class
    
    class << self

      # -------------------      
      # Elements
      
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
      
      def scpr_class
        SCPR_CLASS
      end
      
      def xml_ar_map
        XML_AR_MAP
      end
      
      
      # -------------------      
      # Node rejectors
      
      def invalid_child(node)
        %w{text comment}.include?(node.name)
      end
      
      def invalid_item(node)
        # Only published content
        node.at_xpath("./wp:status").content != "publish"
      end
      
      # -------------------      
      
      def nested_attributes
        [:@categories, :@postmeta]
      end
    end
    

    # -------------------
    # Instance
    
    def initialize(element)
      @builder = { categories: [], postmeta: [] }
      super(element)
    end
    
    def sorter
      Time.parse(self.pubDate)
    end
    
    
    # -------------------
    # Builder populator
    
    def check_and_merge_nodes(child)
      if is_category(child)
        merge_category(child)
      else
        super
      end
    end
    
    
    # -------------------      
    # Merge in extra attributes
    
    def merge_category(child)
      category = {  title: child.content, 
                    domain: child[:domain], 
                    nicename: child[:nicename] }
      builder[:categories].push category
    end
    
    
    # -------------------
    # Node inspectors
    
    def is_category(child)
      child.name == "category"
    end
    
    
    # -------------------    
    # Import
    
    def import
      if self.imported
        return false
      end
      
      object = SCPR_CLASS.constantize.send("find_or_initialize_by_#{self.class.xml_ar_map.first[1]}", send(self.class.xml_ar_map.first[0]))
      
      if !object.new_record?
        self.ar_record = object
        return false
      end
      
      object_builder = {}
      XML_AR_MAP.each do |wp_attr, ar_attr|
        object_builder.merge!(ar_attr => send(wp_attr))
      end
      
      # Merge in existing author_id if user exists
      # Otherwise it will just use Leslie's ID
      if existing = AdminUser.where(username: self.dc).first
        object_builder[:author_id] = Bio.where(user_id: existing.id).first.id
      end
            
      object_builder.reverse_merge!(DEFAULTS)
      object.attributes = object_builder
            
      if object.save
        # Unset @ar_records so it's forced to reload
        self.class.ar_records = nil
        self.ar_record = object
        return self
      else
        return false
      end
    end
    
    
    # -------------------
    # Convenience Methods
    
    def to_title
      title
    end
    
    def id
      post_id.to_i
    end
    
    def status=(value)
      status_map = {
        "publish" => 5,
        "inherit" => 5,
        "draft"   => 0
      }
      
      @status = status_map[value]
    end
  end
end
