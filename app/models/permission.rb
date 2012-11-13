##
# Permission
#
class Permission < ActiveRecord::Base
  administrate do
    define_list do
      list_order "resource"
      
      column :admin_user
      column :resource
    end
  end

  #-------------------
  
  has_many :admin_user_permissions
  has_many :admin_users, through: :admin_user_permissions
  
  #-------------------
  
  def title
    self.resource.titleize
  end
end
