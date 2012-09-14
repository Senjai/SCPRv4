module Model
  module Callbacks
    # There you have it.
  end
end

# If you wanted to, you could use this...
# 
# module ActiveRecord
#   class Base
#     if File.exists?("#{Rails.root}/app/models/callbacks/#{self.model_name.underscore}_callback.rb")
#       include "Model::Callbacks::#{self.model_name}Callback".constantize
#     end
#   end
# end
# 
