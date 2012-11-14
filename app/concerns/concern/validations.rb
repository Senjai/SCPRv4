##
# Concern::Validations
#
module Concern
  module Validations
    # Define some defaults
    DEFAULTS = {
      slug_format: %r{^[\w-]+$}
    }
    
    module InstanceMethods
      # This should be true by default,
      # so that it acts strictly if no
      # custom should_validate? method
      # is defined.
      def should_validate?
        true
      end
    end
    
    ActiveRecord::Base.send :include, InstanceMethods
  end
end
