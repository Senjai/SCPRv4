module AudioVision
  class Base

    class << self
      def find(id)
        response = client.get(api_path + "/#{id}")
        
        if response.success?
          new(response.body)
        else
          false
        end
      end

      #-----------------

      private

      def client
        @client ||= AudioVision::Client.new
      end
    end


    # Steal the ActiveRecord behavior for object comparison.
    # If they're the same class and the ID is the same, then it's "same"
    # enough for us.
    def ==(comparison_object)
      super ||
        comparison_object.instance_of?(self.class) &&
        self.id.present? &&
        self.id == comparison_object.id
    end
    alias :eql? :==

  end
end
