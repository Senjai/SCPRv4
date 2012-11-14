##
# Basic setup for Concern::Methods
#
module Concern
  module Methods
    # Okedoke
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/concern/methods/#{self.model_name.underscore}_methods.rb")
#       include "Concern::Methods::#{self.model_name}Methods".constantize
#     end
#   end
# end
# 
