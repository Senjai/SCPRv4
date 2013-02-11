##
# Outpost::Controller
#
module Outpost
  module Controller
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern
    
    included do
      include Outpost::Controller::Actions
      include Outpost::Controller::Helpers
    end
    
    autoload :Actions
    autoload :Helpers
  end # Controller
end # Outpost
