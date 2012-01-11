namespace :scprv4 do 
  
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