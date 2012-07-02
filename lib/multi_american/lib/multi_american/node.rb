module WP
  class Node
    extend AdminResource
        
    # -------------------      
    # Resque

    class ImportJob
      @queue = Rails.application.config.scpr.resque_queue
      
      class << self
        def after_perform(resource_class, document_path, username, id)
          Rails.logger.info "Performed ImportJob for #{@queue}, sending to #{username}"
          NodePusher.publish("finished_queue", username, { wp_id: id, resource_class: resource_class } )
        end

        def perform(resource_class, document_path, username, id)
          @doc = WP::Document.new(document_path)            
          @objects = resource_class.constantize.find(@doc)
          
          # If we're given an id, only import that one
          if id
            if obj = @objects.find { |r| r.id == id.to_i }
              return obj.import
            else
              return false
            end
          else
            # Otherwise import all of them
            @objects.each do |obj|
              obj.import
            end
            return true
          end
        end
      end
    end

    class RemoveJob
      @queue = Rails.application.config.scpr.resque_queue
      
      class << self
        def after_perform(resource_class, document_path, username, id)
          Rails.logger.info "Performed RemoveJob for #{@queue}, sending to #{username}"
          NodePusher.publish("finished_queue", username, { wp_id: id, resource_class: resource_class } )
        end

        def perform(resource_class, document_path, username, id)
          @doc = WP::Document.new(document_path)
          @objects = resource_class.constantize.find(@doc)
          
          # If we're given an id, only remove that one
          if id
            if obj = @objects.find { |r| r.id == id.to_i }
              return obj.remove
            else
              return false
            end
          else
            # Otherwise remove all
            @objects.each do |obj|
              obj.remove
            end
            return true
          end
        end
      end
    end
        
    # -------------------
    # Class
    
    class << self
      
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
        @elements ||= doc.xpath(XPATH)
      end
      
      # Set initial AR Records
      # This will update when something is imported
      attr_writer :ar_records
      def ar_records
        @ar_records ||= self.scpr_class.constantize.unscoped.reload.all.map { |r| { wp_id: r.wp_id, identifier: r.send(self.xml_ar_map.first[1]) } }
      end
      

      # -------------------
      # Node Finder
      
      def find(doc)
        Rails.logger.info "*** Finding #{self.name} in #{doc.url}"
        new_records = []
      
        elements(doc).reject { |i| invalid_item(i) }.each do |element|
          new_records.push self.new(element)
        end
        
        new_records
      end


      # -------------------      
      # Node rejectors
      
      def invalid_child(node)
        %w{text}.include?(node.name)
      end
    
      def invalid_item(node)
        # Accept all by default
        false
      end
      
      
      # -------------------      
      # Dummy NESTED_ATTRIBUTES for classes that don't need it
      
      def nested_attributes
        []
      end
    end
    
    
    # -------------------
    # Instance
    
    attr_accessor :builder
    
    def initialize(element)
      Rails.logger.info "*** Initializing a new #{self.class.name}"
      # Default builder
      @builder ||= { }

      element.children.reject { |c| self.class.invalid_child(c) }.each do |child|
        check_and_merge_nodes(child)
      end
      
      @builder.each { |a, v| send("#{a}=", v) }
    end
    
    
    # -------------------            
    # Remove (opposite of Import)
    def remove
      ::Rails.logger.info "Removing...."
      
      if self.ar_record.blank?
        Rails.logger.info "no record"
        return false
      else
        # Only remove objects if they have a wp_id
        if !self.ar_record.wp_id or self.ar_record.delete
          self.class.ar_records = nil
          return self
        else
          return false
        end
      end
    end
    
    
    # Some checks to see if it's already been imported or it already exists
    def ar_record
      self.class.scpr_class.constantize.where(self.class.xml_ar_map.first[1] => send(self.class.xml_ar_map.first[0])).reload.first
    end
      
    def exists_in_db
      self.ar_record.present?
    end
    
    def imported
      self.exists_in_db and self.ar_record.wp_id.present?
    end
    
    
    # Assume all instance variables
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
    # Builder populator
    
    def check_and_merge_nodes(child)
      if is_postmeta(child) and builder.has_key? :postmeta
        # Grab the post meta and merge it into the hash appropriately
        merge_postmeta(child)
      
      elsif has_other_namespace(child)
        # This is for stuff like content:encoded, excerpt:encoded
        merge_other_namespaces(child)
      
      else
        # Basic behavior
        builder.merge!(child.name.gsub(/\W/, "_") => child.content)
      end
    end
    
    
    # -------------------      
    # Merge in extra attributes
    
    def merge_postmeta(child)
      postmeta = {  meta_key: child.at_xpath("./wp:meta_key").content, 
                    meta_value: child.at_xpath("./wp:meta_value").content }
      builder[:postmeta].push postmeta
    end

    def merge_other_namespaces(child)
      builder.merge!(child.namespace.prefix => child.children.first.content)
    end
    
    
    # -------------------
    # Node inspectors
    
    def is_postmeta(child)
      child.name == "postmeta"
    end
    
    def has_other_namespace(child)
      child.namespace.present? && !%w{ wp }.include?(child.namespace.prefix)
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
