## 
# AdminResource::Admin
#
module AdminResource
  class Admin
    attr_accessor :model
    attr_reader   :list
    
    def initialize(klass)
      @model = klass
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
