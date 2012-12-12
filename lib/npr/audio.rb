module NPR
  class Audio
    def initialize(@attributes={})
    end
    
    def method_missing(method, *args, &block)
      @attributes[method] || super
    end
  end
end
