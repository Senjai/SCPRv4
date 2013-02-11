class BootstrapPermissionsWithOutpost < ActiveRecord::Migration
  def up
    Outpost.config.registered_models.each do |model|
      Permission.create(resource: model)
    end
  end

  def down
    Permission.delete_all
  end
end
