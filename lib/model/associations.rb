##
# Basic setup for Model::Associations
#
module Model
  module Associations
    # okedoke
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/models/associations/#{self.model_name.underscore}_association.rb")
#       include "Model::Associations::#{self.model_name}Association".constantize
#     end
#   end
# end
# 
