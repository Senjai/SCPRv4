module Model
  module Validations  
    # Define some defaults
    DEFAULTS = {
      slug_format: %r{[\w-]+}
    }
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/models/validations/#{self.model_name.underscore}_validation.rb")
#       include "Model::Validations::#{self.model_name}Validation".constantize
#     end
#   end
# end
# 
