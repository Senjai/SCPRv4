module Secretary
  module HasSecretary
    def self.included(base)
      base.send :extend, ClassMethods
    end
    
    module ClassMethods
      def has_secretary(options={})
        has_many :versions, class_name: "Secretary::Version", as: :versioned, dependent: :destroy
        attr_accessor :logged_user_id
        attr_reader :dirty
      
        before_update :store_object
        after_update  :generate_version
            
        send :include, InstanceMethods
      end
    end
    
    module InstanceMethods
      def store_object
        @dirty = self.class.find(self.id)
      end
      
      def generate_version
        Version.generate(self)
      end      
    end
  end  
end
