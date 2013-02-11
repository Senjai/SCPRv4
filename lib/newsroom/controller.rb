##
# Newsroom::Controller
#
module Newsroom
  module Controller
    extend ActiveSupport::Autoload
    extend ActiveSupport::Concern
    
    included do
      include Newsroom::Controller::Actions
      include Newsroom::Controller::Helpers
    end
    
    autoload :Actions
    autoload :Helpers
  end # Controller
end # Newsroom
