##
# Basic setup for Concern::Scopes
#
module Concern
  module Scopes
    # okedoke
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/concern/scopes/#{self.model_name.underscore}_scope.rb")
#       include "Concern::Scopes::#{self.model_name}Scope".constantize
#     end
#   end
# end
# 
