module WP
  class Node
    extend AdminResource
    include WP::Builder
    
    # -------------------
    # Class
    
    class << self
      
      # -------------------
      # Class cache key
      def cache_key
        [WP::CACHE_KEY, WP::Document::CACHE_KEY, self::CACHE_KEY].join(":")
      end
      
      
      # -------------------      
      # Templates
      
      def index_template
        "resource_index"
      end
      
      def detail_template
        "resource_show"
      end
      
      
      # -------------------      
      # Elements
      
      def elements(doc)
        doc.xpath(XPATH)
      end
      

      # -------------------
      # Node Finder
      def find(doc)
        # Check if we have cached objects...
        if keys = WP.rcache.smembers(self.cache_key)
          objects = []
          
          keys.each do |key| 
            objects.push YAML.load(WP.rcache.get key)
          end
          
          return objects
        else
          # If not, initialize new objects
          new_records = []
      
          self.elements(doc).reject { |i| invalid_item(i) }.each do |element|
            new_records.push self.new(element)
          end
          
          return new_records
        end
      end
    end
    
    
    # -------------------
    # Instance
        
    def initialize(element)
      # Default builder
      @builder ||= { }

      element.children.reject { |c| self.class.invalid_child(c) }.each do |child|
        check_and_merge_nodes(child)
      end
      
      @builder.each { |a, v| send("#{a}=", v) }
      
      # Write to cache & Add to set
      WP.rcache.set self.cache_key self.to_yaml
      WP.rcache.sadd self.class.cache_key self.cache_key
    end
    
    
    # -------------------
    # Instance cache key
    def cache_key
      [WP::CACHE_KEY, WP::Document::CACHE_KEY, self.class.name.underscore, self.id].join(":")
    end
    
    
    # -------------------            
    # Remove (opposite of Import)
    def remove
      # Only remove objects that were imported
      if !self.imported?
        return false
      else
        self.ar_record.delete
        WP.rcache.srem self.class.cache_key self.cache_key
        WP.rcache.delete self.cache_key
      end
    end
    
    
    # -------------------
    # Find the AR record based on the XML_AR_MAP hash
    def ar_record
      self.class.scpr_class.constantize.where(self.class.xml_ar_map.first[1] => send(self.class.xml_ar_map.first[0])).reload.first
    end

    # -------------------    
    # Check to see if it was imported
    # Based on the presence of wp_id
    def imported
      self.ar_record and self.ar_record.wp_id.present?
    end
    
    
    # -------------------
    # Attributes
    def attributes
      instance_variables - [:@builder]
    end
    
    def id
      send("#{self.class.name.underscore}_id")
    end
    
    def to_title
      "#{self.class.to_s.titleize} ##{id}"
    end
    
    def sorter
      id
    end
    
    
    # -------------------
    # Dynammic accessor
    def method_missing(method, *args, &block)
      if method =~ /=$/
        return instance_variable_set("@#{method.to_s.gsub(/\W/, "")}", args.first)
      else
        if var = instance_variable_get("@#{method.to_s.gsub(/\W/, "")}")
          return var
        else
          super
        end
      end
    end
  end
end
