## 
# AdminResource::Admin
#
module AdminResource
  class Admin
    
    DEFAULTS = {
      excluded_fields:  ["id", "created_at", "updated_at"]
    }
    
    attr_accessor :model
    attr_reader   :list
    
    def initialize(class_name)
      @model = class_name
      @list  = List::Base.new
    end
    
    #------------
    
    def define_list(&block)
      list.instance_eval &block
    end
    
    def fields
      []
    end
  end
end
