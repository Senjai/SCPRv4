class AddAdminResourcePermissions < ActiveRecord::Migration
  def up
    AdminResource.config.registered_models.each do |resource|
      Permission::DEFAULT_ACTIONS.each do |action|
        Permission.create(resource: resource, action: action)
      end
    end
  end

  def down
    Permission.delete_all
  end
end
