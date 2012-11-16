##
# CacheTasks
#
# An API for caching, and enqueing caching.
# Meant to be run mostly as rake tasks.
#
# Each task should respond to a #run method.
#
module CacheTasks
  class Task
    attr_accessor :verbose
    
    def cacher
      @cacher ||= CacheController.new
    end

    #---------------
    
    def cache(*args)
      cacher.cache(*args)
    end
    
    #---------------
    
    def enqueue(job_class=nil)
      job_class ||= Job::CacheTask
      Resque.enqueue(job_class, self.class.name)
    end
    
    #---------------
    
    def log(message)
      message = "*** #{message}"
      
      # Rails log always gets it
      Rails.logger.info message
      
      # STDOUT only gets it if requested
      if @verbose
        $stdout.puts message
      end
    end
  end # Task
end # CacheTasks

Dir["#{Rails.root}/cache_tasks/*"].each { |f| require f }
