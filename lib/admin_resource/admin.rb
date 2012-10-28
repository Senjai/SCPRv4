## 
# AdminResource::Admin
#
module AdminResource
  class Admin
    attr_accessor :model, :fields
    attr_reader   :list
    
    def initialize(klass)
      @model = klass
      @list  = List::Base.new
    end
    
    #------------
    
    def define_list(&block)
      @list_defined = true
      list.instance_eval &block
    end

    #------------
    
    def list_defined?
      !!@list_defined
    end
    
    #------------
    # Eventually might add support for defining form
    # fields in the model. For now this method will
    # just always be false.
    def fields_defined?
      !!@fields_defined
    end
  end
end
