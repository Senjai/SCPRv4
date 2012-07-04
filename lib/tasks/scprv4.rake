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
      puts "Finished.\n"
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
      puts "Caching tweets...."
      cache_tweets("KPCCForum")
      puts "Finished.\n"
    end
    
    #----------
    
    desc "Cache external programs"
    task :programs => [ :environment ] do
      puts "Caching remote programs..."
      OtherProgram.active.each { |p| p.cache }
      puts "Finished.\n"
    end
    
    #----------
    
    desc "Cache homepage one time"
    task :homepage => [ :environment ] do
      puts "Caching homepage..."
      require 'rubypython'
    
      # load python
      RubyPython.start()      
      pickle = RubyPython.import("cPickle")
    
      HomeController._cache_homepage(nil,pickle)
      puts "Finished.\n"
    end
    
    desc "Cache everything"
    task :all => [:environment, :remote_blogs, :programs, :homepage, :tweets]
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
    
    desc "Start an Email listener"
    task :email => [ :environment ] do 
      require 'email_worker'
    
      begin
        worker = EmailWorker.new()
        worker.verbose = ENV['LOGGING'] || ENV['VERBOSE']
      rescue
        abort "Failed to launch EmailWorker!"
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

# Easy database syncing for development

db_namespace = namespace :db do
  namespace :mercer do
    task :pull => [:fetch, :merge] # rsync and merge
    task :clone => [:clone_dump, :purge, :merge] # scp, purge and merge
    
    # rsync the dump file on db1
    task :fetch => :dump_file_config do
      $stderr.puts "Fetching mercer.dump from 66.226.4.229 using rsync"
      `rsync -v 66.226.4.229:~scprdb/mercer.dump #{Rails.application.config.scpr.mercer_dump}`
      $stderr.puts "Finished."
    end
  
    # Merge dump file schema into current database.
    task :merge => :dump_file_config do
      $stderr.puts "Dumping data from #{Rails.application.config.scpr.mercer_dump} into #{ActiveRecord::Base.configurations[Rails.env]['database']}"
      `mysql -u root #{ActiveRecord::Base.configurations[Rails.env]['database']} < #{Rails.application.config.scpr.mercer_dump}`
      $stderr.puts "Finished."
    end
  
    task :purge do
      db_namespace[:purge].invoke
    end
            
    task :clone_dump => :dump_file_config do
      $stderr.puts "Fetching mercer.dump from 66.226.4.229 using scp"
      `scp 66.226.4.229:~scprdb/mercer.dump #{Rails.application.config.scpr.mercer_dump.split("/").tap { |a| a.pop }.join("/")}/`
      $stderr.puts "Finished."
    end
  
    task :dump_file_config => :environment do
      if Rails.application.config.scpr.mercer_dump.blank?
        raise "No mercer dump file specified for this environment."
      else
        $stderr.puts Rails.application.config.scpr.mercer_dump
      end
    end
  end
end
