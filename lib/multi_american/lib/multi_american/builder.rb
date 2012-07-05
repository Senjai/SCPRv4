module WP
  module Builder
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      # -------------------      
      # Node rejectors
      
      def invalid_child(node)
        %w{text}.include?(node.name)
      end

      # -------------------      
    
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
    # Instance Methods
    
    # -------------------
    # Builder populator
    def check_and_merge_nodes(child)
      if is_postmeta(child) and @builder.has_key? :postmeta
        # Grab the post meta and merge it into the hash appropriately
        merge_postmeta(child)
      
      elsif has_other_namespace(child)
        # This is for stuff like content:encoded, excerpt:encoded
        merge_other_namespaces(child)
      
      else
        # Basic behavior
        @builder.merge!(child.name.gsub(/\W/, "_") => child.content)
      end
    end
    
    
    # -------------------      
    # Merge in extra attributes
    
    def merge_postmeta(child)
      postmeta = {  meta_key: child.at_xpath("./wp:meta_key").content, 
                    meta_value: child.at_xpath("./wp:meta_value").content }
      @builder[:postmeta].push postmeta
    end

    # -------------------      

    def merge_other_namespaces(child)
      @builder.merge!(child.namespace.prefix => child.children.first.content)
    end
    
    
    # -------------------
    # Node inspectors
    
    def is_postmeta(child)
      child.name == "postmeta"
    end
    
    # -------------------      
    
    def has_other_namespace(child)
      child.namespace.present? && !%w{ wp }.include?(child.namespace.prefix)
    end
    
  end
end
