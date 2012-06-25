module WP
  class Node
    
    # -------------------
    # Class
    
    class << self
      
      # -------------------      
      # Templates
      
      def index_template
        "#{self.name.underscore.pluralize}_index"
      end
      
      def detail_template
        "#{self.name.underscore.pluralize}_detail"
      end
      
      
      # -------------------      
      # Elements
      
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
      

      # -------------------
      # Node Finder
      
      def find(doc)
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
    end
    
    
    # -------------------
    # Instance
    
    attr_accessor :builder
    
    def initialize(element)
      # Default builder
      @builder ||= { postmeta: [] }
      
      element.children.reject { |c| self.class.invalid_child(c) }.each do |child|
        check_and_merge_nodes(child)
      end
      
      builder.each { |a, v| send("#{a}=", v) }
    end
    
    # Assume all instance variables
    def attributes
      instance_variables - [:@builder]
    end
    
    def sorter
      id
    end
        
    # -------------------
    # Builder populator
    
    def check_and_merge_nodes(child)
      if is_postmeta(child)
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
        return instance_variable_set("@#{method.to_s.chomp("=")}", args.first)
      else
        if var = instance_variable_get("@#{method}")
          return var
        else
          super
        end
      end
    end
  end
end
