##
# Basic setup for Concern::Validations
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

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/concern/validations/#{self.model_name.underscore}_validation.rb")
#       include "Concern::Validations::#{self.model_name}Validation".constantize
#     end
#   end
# end
# 
