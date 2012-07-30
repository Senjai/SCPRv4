# Easy database syncing for development

namespace :dbsync do
  task :dump_file_config => :environment do
    DUMP = Rails.application.config.dbsync
    
    DUMP['remote']  = "~#{DUMP['user']}/#{DUMP['file']}"
    DUMP['local']   = File.join DUMP['dir'], DUMP['file']
    DUMP['db']      = ActiveRecord::Base.configurations[Rails.env]['database']
    
    if DUMP['local'].blank?
      raise "No local dump file specified."
    elsif DUMP['remote'].blank?
      raise "No remote dump file specified."
    elsif DUMP['db'].blank?
      raise "No database specified"
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
  
  desc "Copy the remote dump file, purge the local database, and load in the dump file"
  task :clone => [:clone_dump, :purge, :merge]
  
  #-----------------------
  
  desc "Update the local dump file from the remote source"
  task :fetch => :dump_file_config do
    $stderr.puts "Fetching #{DUMP['remote']} from #{DUMP['host']} using rsync"
    `rsync -v #{DUMP['host']}:#{DUMP['remote']} #{DUMP['local']}`
    $stderr.puts "Finished."
  end

  desc "Merge the local dump file into the local database"
  task :merge => :dump_file_config do
    $stderr.puts "Dumping data from #{DUMP['local']} into #{DUMP['db']}"
    `mysql -u root #{DUMP['db']} < #{DUMP['local']}`
    $stderr.puts "Finished."
  end

  desc "Copy the remote dump file to a local destination"
  task :clone_dump => :dump_file_config do
    $stderr.puts "Fetching #{DUMP['remote']} from #{DUMP['host']} using scp"
    `scp #{DUMP['host']}:#{DUMP['remote']} #{DUMP['dump_dir']}/`
    $stderr.puts "Finished."
  end

  #-----------------------

  task :purge do
    Rake::Task["db:purge"].invoke
  end
end
