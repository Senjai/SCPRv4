module WP
  class Category < Node
    XPATH = "/rss/channel/wp:category"
    SCPR_CLASS = "BlogCategory"
    CACHE_KEY = "categories"
    
    DEFAULTS = {
      blog_id: MultiAmerican::BLOG_ID
    }
    
    XML_AR_MAP = {
      # XML                 # AR
      category_nicename:    :slug, # Primary
      id:                   :wp_id,
      cat_name:             :title
    }
    
    administrate!
    self.list_fields = [
      ['id', title: "Term ID"],
      ['cat_name', link: true, title: "Name"],
      ['category_nicename', title: "Slug"]
    ]
    
    # -------------------
    # Class
    
    class << self

      # -------------------      
      # Elements
      def elements(doc)
        doc.xpath(XPATH)
      end
      
      def scpr_class
        SCPR_CLASS
      end
      
      def xml_ar_map
        XML_AR_MAP
      end
    end
    
    # -------------------
    # Instance
    
    def import
      # Short circuit so we can be sure not to overwrite anything
      if self.imported
        return false
      end
      
      object = SCPR_CLASS.constantize.send("find_or_initialize_by_#{self.class.xml_ar_map.first[1]}", send(self.class.xml_ar_map.first[0]))
      
      # Handle what to do if the object already exists
      if !object.new_record?
        self.ar_record = object
        return false
      end
      
      object_builder = {}
      XML_AR_MAP.each do |wp_attr, ar_attr|
        object_builder.merge!(ar_attr => send(wp_attr))
      end
          
      object_builder.reverse_merge!(DEFAULTS)
      object.attributes = object_builder
        
      if object.save
        self.ar_record = object
        return self
      else
        return false
      end
    end
    
    # -------------------
    # Convenience Methods
    
    def id
      term_id.to_i
    end
    
    def to_title
      cat_name
    end
  end
end