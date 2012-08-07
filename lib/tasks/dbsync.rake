# Easy database syncing for development

desc "Alias for dbsync:pull"
task :dbsync do
  Rake::Task["dbsync:pull"].invoke
end

namespace :dbsync do
  task :dump_file_config => :environment do
    if Rails.env == 'production'
      raise "These tasks are destructive and shouldn't be used in the production environment."
    end
    
    DUMP  = Rails.application.config.dbsync
    DB    = ActiveRecord::Base.configurations[Rails.env]
    
    DUMP['remote']  = "#{DUMP['remote_host']}:" + File.join(DUMP['remote_dir'], DUMP['filename'])
    DUMP['local']   = File.join DUMP['local_dir'], DUMP['filename']

    if DUMP['filename'].blank?
      raise "No dump filename specified."
    elsif DUMP['remote'].blank?
      raise "No remote dump file specified."
    end
  end
  
  #-----------------------
  
  desc "Show the configuration"
  task :config => :dump_file_config do
    $stderr.puts "Config: "
    $stderr.puts DUMP.to_yaml
  end
    
  #-----------------------
    
  desc "Update the local dump file, and merge it into the local database"
  task :pull => [:fetch, :merge]
  
  desc "Copy the remote dump file, reset the local database, and load in the dump file"
  task :clone => [:clone_dump, :reset, :merge]
  
  #-----------------------
  
  desc "Update the local dump file from the remote source"
  task :fetch => :dump_file_config do
    $stderr.puts "Fetching #{DUMP['remote']} using rsync"
    `rsync -v #{DUMP['remote']} #{DUMP['local']}`
    $stderr.puts "Finished."
  end

  #-----------------------

  desc "Copy the remote dump file to a local destination"
  task :clone_dump => :dump_file_config do
    $stderr.puts "Fetching #{DUMP['remote']} using scp"
    `scp #{DUMP['remote']} #{DUMP['local_dir']}/`
    $stderr.puts "Finished."
  end

  #-----------------------
  
  desc "Merge the local dump file into the local database"
  task :merge => :dump_file_config do
    $stderr.puts "Dumping data from #{DUMP['local']} into #{DB['database']}"
    `mysql \
    #{"-u "+ DB['username'] if DB['username'].present?} \
    #{"-p " + DB['password'] if DB['password'].present?} \
    #{"-h " + DB['host'] if DB['host'].present?} \
    #{DB['database']} < #{DUMP['local']}`
    $stderr.puts "Finished."
  end

  #-----------------------
  
  task :reset do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
  end
end
