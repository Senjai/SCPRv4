##
# Permission
#
class Permission < ActiveRecord::Base
  administrate
  has_many :admin_user_permissions
  has_many :admin_users, through: :admin_user_permissions
  
  # RESTful actions.
  DEFAULT_ACTIONS = [:show, :update, :create, :destroy]
  
  # Map actions to other similar ones.
  #
  #   :edit  => :update
  #   :new   => :create
  #   :index => :show
  #
  def self.normalize_rest(action)
    action = action.to_s
    case action
    when "edit"   then "update"
    when "new"    then "create"
    when "index"  then "show"
    else action
    end
  end
end
