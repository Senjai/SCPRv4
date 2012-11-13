module AdminResource
  module Test
    class PeopleController < ActionController::Base
      include AdminResource::Controller::Actions
  
      def params
        {
          controller: "admin/people"
        }
      end
    end # PeopleController
  end # Test
end # AdminResource
