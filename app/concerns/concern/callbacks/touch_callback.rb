##
# TouchCallback
# 
# For a record to be updated whenever its before_save
# is called.
#
# https://github.com/rails/rails/issues/8759
module Concern
  module Callbacks
    module TouchCallback
      extend ActiveSupport::Concern

      included do
        # If the content was actually changed, then Rails will update
        # the timestamp for us. If it wasn't changed, then we want to
        # update the timestamp ourselves, for cache expiration.
        after_save -> { self.touch }, unless: -> { self.changed? }
      end
    end
  end
end
