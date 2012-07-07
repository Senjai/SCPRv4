module WP
  class Tag < Node
    XPATH = "/rss/channel/wp:tag"
    CACHE_KEY = "tags"
    
    SCPR_CLASS = "Tag"
    XML_AR_MAP = {
      tag_slug:   :slug,
      id:         :wp_id,
      tag_name:   :name
    }
    
    DEFAULTS = {}
    
    administrate!    
    self.list_fields = [
      ['id', title: "Term ID"],
      ['tag_slug', link: true, title: "Name"],
      ['tag_name']
    ]
    self.list_per_page = 50

    
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
      tag_name
    end
  end
end