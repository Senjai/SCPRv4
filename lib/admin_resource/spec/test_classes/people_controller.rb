module AdminResource
  module Test
    class PeopleController < ActionController::Base
      include AdminResource::Controller::Actions # Auto-magically includes Helpers as well
      include AdminResource::Breadcrumbs
  
      def params
        {
          controller: "admin/people"
        }
      end
    end # PeopleController
  end # Test
end # AdminResource
