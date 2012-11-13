##
# AdminResource::Model
#
module AdminResource
  module Model
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern
    
    included do
      include AdminResource::Model::Methods
      include AdminResource::Model::Routing
    end
    
    autoload :Methods
    autoload :Routing
  end
end
