module AdminResource
  class Admin
    attr_accessor :model
    attr_reader   :list
    
    def initialize(class_name)
      @model = class_name
      @list  = List.new
    end
    
    #------------
    
    def define_list
      yield list
    end
    
    def fields
      []
    end
  end
end
