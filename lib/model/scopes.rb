##
# Basic setup for Model::Scopes
#
module Model
  module Scopes
    # okedoke
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/models/scopes/#{self.model_name.underscore}_scope.rb")
#       include "Model::Scopes::#{self.model_name}Scope".constantize
#     end
#   end
# end
# 
