module AdminResource
  class Config

    # Pass a block to this method to define the configuration
    # If no block is passed, config will be defaults
    def self.configure
      config = new
      yield config if block_given?
      AdminResource.config = config
    end
    
    #------------------
    
    attr_writer :registered_models
    def registered_models
      @registered_models || []
    end
  end
end
