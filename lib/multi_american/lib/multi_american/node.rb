module WP
  class Node
    extend AdminResource
    include WP::Builder
    
    DEFAULTS = {}
    
    # -------------------
    # Class
    
    class << self
      
      # -------------------
      # Class cache key
      def cache_key
        [WP::CACHE_KEY, WP::Document::CACHE_KEY, self::CACHE_KEY].join(":")
      end
      
      attr_writer :cached
      def cached
        @cached ||= WP.rcache.smembers(self.cache_key).map { |c| YAML.load(WP.rcache.get c) }
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
        doc.xpath(self::XPATH)
      end
      
      def scpr_class
        self::SCPR_CLASS
      end
      
      def xml_ar_map
        self::XML_AR_MAP
      end
      
      def defaults
        self::DEFAULTS
      end
      

      # -------------------
      # Node Finder
      def find(doc=nil)
        # IF we pass in a doc, force a reload of the resources
        if doc.present?
          new_records = []
      
          self.elements(doc).reject { |i| invalid_item(i) }.each do |element|
            new_records.push self.new(element)
          end
          
          self.total = new_records.size
          Rails.logger.info "*** #{self.name} loaded."
          return new_records
        else
          # Otherwise, just return the cache (which may be blank)
          return self.cached
        end
      end
      
      def total
        WP.rcache.get([self.cache_key, "total"].join(":"))
      end
      
      def total=(val)
        WP.rcache.set([self.cache_key, "total"].join(":"), val)
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

      # No need to store the info from @builder
      self.send(:remove_instance_variable, :@builder)
      
      # Write to cache & Add to set
      WP.rcache.sadd self.class.cache_key, self.cache_key
      WP.rcache.set self.cache_key, self.to_yaml
    end
    
    
    # -------------------
    # Instance cache key
    def cache_key
      [self.class.cache_key, self.id].join(":")
    end
    
    
    # -------------------            
    # Import
    def import
      # Don't want to duplicate objects
      if self.imported
        return false
      end
      
      object = self.class.scpr_class.constantize.send("find_or_initialize_by_#{self.class.xml_ar_map.first[1]}", send(self.class.xml_ar_map.first[0]))
      
      if !object.new_record?
        self.ar_record = object
        return false
      end
      
      object_builder = {}
      self.class.xml_ar_map.each do |wp_attr, ar_attr|
        object_builder.merge!(ar_attr => send(wp_attr))
      end
      
      # Setup any extra stuff that needs to be setup
      object, object_builder = build_extra_attributes(object, object_builder)
      
      object_builder.reverse_merge!(self.class.defaults)
      object.attributes = object_builder
            
      object.save
    end
    
    def build_extra_attributes(object, object_builder)
      true
    end
    
    # -------------------            
    # Remove (opposite of Import)
    def remove
      # Only remove objects that were imported
      if !self.imported
        return false
      end

      self.ar_record.delete
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
      instance_variables
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
