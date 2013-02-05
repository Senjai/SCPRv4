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
      # Whether or not to validate this object,
      # for any validations that have the condition:
      # `if: :should_validate?`
      #
      # Check for @_force_validation first
      # so we can stub this method if needed,
      # for previewing for example.
      def should_validate?
        @_force_validation == true || needs_validation?
      end

      #--------------------
      # Whether or not this object needs to be
      # validated. This is ususually reserved
      # for "whenever this object is going live".
      #
      # True by default, so that if it's not 
      # overridden then it will always validate.
      #
      # This should be true by default,
      # so that it acts strictly if no
      # custom should_validate? method
      # is defined.
      def needs_validation?
        true
      end

      #--------------------
      # Allows us to check whether a record
      # will be valid when #should_validate?
      # is true.
      #
      # Example:
      #
      #   class Event
      #     validates_presence_of :headline, if: :should_validate?
      #   end
      #
      #   @event = Event.new
      #   @event.should_validate? #=> false
      #   @event.valid? #=> true
      #   @event.unconditionally_valid? #=> false
      #
      def unconditionally_valid?
        @_force_validation = true
        self.valid?
      end
    end
    
    ActiveRecord::Base.send :include, InstanceMethods
  end
end
