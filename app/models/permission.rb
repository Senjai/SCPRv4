##
# Permission
#
class Permission < ActiveRecord::Base
  #------------------
  # Administration
  administrate do
    define_list do
      list_order "resource"
      
      column :admin_user
      column :resource
    end
  end

  
  #-------------------
  # Association
  has_many :admin_user_permissions
  has_many :admin_users, through: :admin_user_permissions
  
  
  #-------------------
  # Validation
  validates :resource, uniqueness: true
  
  
  #-------------------
  
  def title
    self.resource.titleize
  end
end
