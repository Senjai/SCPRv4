module Secretary
  class Config
    DEFAULTS = { user_class: "::User" }
    
    # Pass a block to this method to define the configuration
    # If no block is passed, config will be defaults
    def self.configure
      config = new
      yield config if block_given?
      Secretary.config = config
    end
    
    #---------------
    
    attr_writer :user_class
    def user_class
      @user_class || DEFAULTS[:user_class]
    end
  end
end
