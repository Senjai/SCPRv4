##
# AdminUserPermission
#
# Join model
#
class AdminUserPermission < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :permission
end
