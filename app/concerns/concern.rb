##
# Concern
#
# A set of mixins for classes.
#
# You can also use it to define your mixins
# in a more rails-y manner:
#
#   class User < ActiveRecord::Base
#     associations do
#       concern :profile_association
#       has_many :comments
#     end
#   end
#
module Concern
  extend ActiveSupport::Concern
  
  # Takes an underscored version of a module name.
  # If the module doesn't exist, you will get an error.
  def concern(module_name)
    name = module_name.to_s.classify
    include "::Concern::#{@mod_name}::#{name}".constantize
  end
  
  def scopes
    @mod_name = "Scopes"
    yield self
  end
  
  def associations
    @mod_name = "Associations"
    yield self
  end
  
  def validations
    @mod_name = "Validations"
    yield self
  end
  
  def callbacks
    @mod_name = "Callbacks"
    yield self
  end
end

ActiveRecord::Base.send :extend, Concern
