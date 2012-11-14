##
# Basic setup for Concern::Associations
#
module Concern
  module Associations
    # okedoke
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/concern/associations/#{self.model_name.underscore}_association.rb")
#       include "Concern::Associations::#{self.model_name}Association".constantize
#     end
#   end
# end
# 
