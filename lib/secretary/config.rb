module Secretary
  module Config
    
    #---------------

    def self.user_class
      @user_class || "::User"
    end
    
    def self.user_class=(val)
      @user_class = val
    end
    
    #---------------
    
  end
end
