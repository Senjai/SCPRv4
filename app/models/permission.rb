##
# Permission
#
class Permission < ActiveRecord::Base
  belongs_to :admin_user
  
  # If not using AdminResource, just provide an array of
  # models that should be included in the list
  ACTIONS = [:show, :create, :update, :destroy]
  
  def self.collection
  end
end
