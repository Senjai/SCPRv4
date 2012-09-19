##
# Basic setup for Model::Methods
#
module Model
  module Methods
    # Okedoke
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/models/model/methods/#{self.model_name.underscore}_methods.rb")
#       include "Model::Methods::#{self.model_name}Methods".constantize
#     end
#   end
# end
# 
