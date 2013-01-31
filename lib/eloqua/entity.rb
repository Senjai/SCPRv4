##
# Eloqua::Entity
#
module Eloqua
  class Entity
    
    class << self
      #--------------------
      # Path for the class
      def path
        self::PATH
      end
      
      #--------------------
      # Find by ID
      def find_by_id(id)
        resp = client.get "#{self.path}/#{id}"
        process_response(resp)
      end
      
      #--------------------
      # Create by attributes
      def create(attributes={})
        resp = client.post self.path, attributes
        process_response(resp)
      end

      #--------------------
      
      def client
        @client ||= Eloqua::Client.new(API_KEYS['eloqua'])
      end

      #--------------------
      
      def process_response(resp)
        if resp.body.present?
          new(resp.body)
        else
          nil
        end
      end
    end

    #--------------------
    # Lazy initialize
    # TODO make it better
    def initialize(attributes={})
      attributes.each do |k, v|
        instance_variable_set "@#{k}", v
      end
    end
    
    #--------------------
    # Path for this object
    def path
      "#{self.class.path}/#{self.id}"
    end
    
    #--------------------
    # Update by attributes
    def update(attributes={})
      resp = self.class.client.put self.path, attributes
      self.class.process_response(resp)
    end

    #--------------------
    # Delete by ID
    def destroy(id)
      resp = self.class.client.delete self.path
      self.class.process_response(resp)
    end
  end
end
