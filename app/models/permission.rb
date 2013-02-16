##
# Permission
#
class Permission < ActiveRecord::Base
  #-------------------
  # Association
  has_many :admin_user_permissions
  has_many :admin_users, through: :admin_user_permissions, dependent: :destroy
  
  #-------------------
  # Validation
  validates :resource, uniqueness: true
  
  #-------------------
  
  def title
    self.resource.titleize
  end
end
