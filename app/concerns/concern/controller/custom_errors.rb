##
# CustomErrors
#
# Custom error handling
#
module Concern
  module Controller
    module CustomErrors
      extend ActiveSupport::Concern
      
      included do
        unless Rails.application.config.consider_all_requests_local
          rescue_from StandardError, with: ->(e) { render_error(500, e) }
          rescue_from ActionController::RoutingError, ActionView::MissingTemplate, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: ->(e) { render_error(404, e) }
        end
      end
      
      #----------------------
      
      def render_error(status, e=StandardError)
        render template: "/errors/error_#{status}", status: status, locals: { errors: e }
        report_error(e)
      end
      
      #----------------------

      def report_error(e)
        ::NewRelic.log_error(e)
      end
    end # CustomErrors
  end # Controller
end # Concern
