module Outpost
  module Test
    class PeopleController < ActionController::Base
      include Outpost::Controller::Actions # Auto-magically includes Helpers as well
      include Outpost::Breadcrumbs
  
      def params
        {
          controller: "admin/people"
        }
      end
    end # PeopleController
  end # Test
end # Outpost
