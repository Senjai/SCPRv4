module Secretary
  module HasSecretary
    # has_secretary
    # Apply to any class that should be versioned
    #
    def has_secretary(options={})      
      has_many :versions, class_name: "Secretary::Version", as: :versioned, dependent: :destroy
      attr_accessor :logged_user_id, :action

      before_create :set_create
      before_update :set_update
      after_save    :generate_version, if -> { self.changed_attributes.present? }
      after_save    :clean_action
      
      send :include, InstanceMethods
    end
    
    module InstanceMethods
      def generate_version
        Version.generate(self)
      end
      
      #-----------
      
      def set_create
        self.action = :create
      end
      
      def set_update
        self.action = :update
      end
      
      #-----------
      
      def clean_action
        @action = nil
      end
    end
  end  
end
