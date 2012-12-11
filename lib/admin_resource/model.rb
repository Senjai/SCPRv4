##
# AdminResource::Model
#
module AdminResource
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern
    
    included do
      include Methods, Identifier, Routing, Naming, Serializer
    end
    
    autoload :Methods
    autoload :Identifier
    autoload :Routing
    autoload :Naming
    autoload :Serializer
  end
end
