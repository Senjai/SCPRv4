namespace :scprv4 do 
  
  desc "Clear events cache"
  task :clear_events => [ :environment ] do 
    Rails.cache.delete("views/mega_events_upcoming")
  end
  
  #----------
  
  desc "Cache homepage one time"
  task :homepage_once => [ :environment ] do
    require 'rubypython'
    
    # load python
    RubyPython.start()      
    pickle = RubyPython.import("cPickle")
    
    HomeController._cache_homepage(nil,pickle)
  end
  
  #----------
  
  desc "Start a Homepage listener"
  task :homepage => [ :environment ] do 
    require 'homepage_worker'
    
    begin
      worker = HomepageWorker.new()
      worker.verbose = ENV['LOGGING'] || ENV['VERBOSE']
    rescue
      abort "Failed to launch HomepageWorker!"
    end
    
    if ENV['BACKGROUND']
      unless Process.respond_to?('daemon')
        abort "env var BACKGROUND is set, which requires ruby >= 1.9"
      end
      Process.daemon(true)
    end
    
    if ENV['PIDFILE']
      File.open(ENV['PIDFILE'], 'w') { |f| f << worker.pid }
    end
    
    worker.log "Starting worker #{worker}"
    
    worker.work()
  end
end

# testing tasks
namespace :db do
  namespace :test do |s|
    s[:prepare].clear
    
    task :prepare => :environment do
      if Rails.application.config.scpr.mercer_dump
        # clear test database
        s[:purge].invoke
        
        # load in mercer dump file
        $stderr.puts "Dumping data from #{Rails.application.config.scpr.mercer_dump} into #{ActiveRecord::Base.configurations['test']['database']}"
        `mysql #{ActiveRecord::Base.configurations['test']['database']} < #{Rails.application.config.scpr.mercer_dump}`
        $stderr.puts "Mercer dump loaded."
      else
        raise "No mercer dump file specified for this environment."
      end
    end
  end
end