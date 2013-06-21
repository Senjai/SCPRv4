class RemoveSectionAndPromotionPermissions < ActiveRecord::Migration
  def up
    s = Permission.where(resource: "Section").first
    p = Permission.where(resource: "Promotion").first
    
    UserPermission.where(permission_id: [s.id, p.id]).delete_all
    s.delete
    p.delete
  end

  def down
    #meh
  end
end
