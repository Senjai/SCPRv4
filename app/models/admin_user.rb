class AdminUser < ActiveRecord::Base
  self.table_name = "auth_user"
  
  scope :active, where(:is_active => true)
end