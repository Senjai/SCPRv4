module WP
  class Tag
    # tag_slug: :slug,
    # tag_name: :name,
    # term_id: :wp_id
    
    DEFAULTS = { }
    
    METHODS = {
      tag_slug: 'slug',
      tag_name: "name",
      term_id: "wp_id"
    }

    class << self
      def filter_values(key, value)
        { METHODS[key].to_sym => send(METHODS[key], value) }
      end
      
      def wp_id(value)
        value
      end
      
      def name(value)
        value
      end
      
      def slug(value)
        value
      end
    end
  end
end