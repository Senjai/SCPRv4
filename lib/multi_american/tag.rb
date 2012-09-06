module MultiAmerican
  class Tag < Node
    XPATH = "/rss/channel/wp:tag"
    
    SCPR_CLASS = "Tag"
    XML_AR_MAP = {
      tag_slug:   :slug,
      id:         :wp_id,
      tag_name:   :name
    }
    
    RAW_REAL_MAP = { 
      nicename: :tag_slug,
      title:    :tag_name
    }
        
    administrate do |admin|
      admin.define_list do |list|
        list.per_page = 50
        
        list.column "id",       header: "Term ID"
        list.column "tag_slug", header: "Name",   linked: true
        list.column "tag_name"
      end
    end

    class << self
      def raw_real_map
        self::RAW_REAL_MAP
      end
    end
    
    # -------------------
    # Instance
    
    def id
      term_id.to_i
    end
    
    def to_title
      tag_name
    end
  end
end
