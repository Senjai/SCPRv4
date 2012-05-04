namespace :scprv4 do 
  
  desc "Clear events cache"
  task :clear_events => [ :environment ] do 
    Rails.cache.expire_obj("events/event:new")
  end
  
  #----------
  
  namespace :cache do
    desc "Cache Remote Blog Entries"
    task :remote_blogs => :environment do
      puts "Caching remote blogs..."
      cached = Blog.cache_remote_entries
      puts "Done!\n"
    end
    
    #----------
    
    desc "Cache tweets"
    task :tweets => :environment do
      require 'twitter_cacher'
      include TwitterCacher
      # Add any more feeds you want to cache. Each feed will be in a cache named `twitter:#{screen_name}`
      ## Ex. twitter:KPCCForum
      # The last argument can optionally be a hash of options to pass the to the Twitter.user_timeline method.
      # These options will be applied to all the feeds being cached. See module TwitterCacher for default options.
      # See the Twitter API docs for more available options: https://dev.twitter.com/docs/api/1/get/statuses/user_timeline
      ## Example usage: cache_tweets("KPCCForum", "SCPR", count: 10, include_rts: false)
      cache_tweets("KPCCForum")
    end
    
    #----------
    
    desc "Cache external programs"
    task :programs => [ :environment ] do
      OtherProgram.active.each { |p| p.cache }
    end
    
    #----------
    
    desc "Cache homepage one time"
    task :homepage => [ :environment ] do
      require 'rubypython'
    
      # load python
      RubyPython.start()      
      pickle = RubyPython.import("cPickle")
    
      HomeController._cache_homepage(nil,pickle)
    end
  end
  
  #----------
  
  namespace :worker do
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
  
    #----------
  
    desc "Start an assethost listener"
    task :assets => [ :environment ] do 
      require 'asset_worker'
    
      begin
        worker = AssetWorker.new()
        worker.verbose = ENV['LOGGING'] || ENV['VERBOSE']
      rescue
        abort "Failed to launch AssetWorker!"
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