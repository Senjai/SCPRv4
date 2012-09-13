# Eager-load every model to register Secretary.versioned_models
Dir[Rails.root.join("app/models/*.rb")].each { |f| load f }

Secretary.versioned_models.each do |model|
  model.constantize.all.each do |record|
    Secretary::Version.generate(record)
    puts "Generated version for #{record.simple_title}"
  end
end