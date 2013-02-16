namespace :admin do
  desc "Update Permissions table with Outpost registered models"
  task :update_permissions => [:environment] do
    Outpost.config.registered_models.each do |model|
      if !Permission.find_by_resource(model)
        $stdout.puts "Adding #{model}"
        Permission.create(resource: model)
      end
    end
  end
end
