module AdminResource
  module Test
    class Pidgeon < ActiveRecord::Base
      include AdminResource::Model::Routing
    end
  end
end
