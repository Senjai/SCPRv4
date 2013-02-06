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
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    attr_accessor :verbose
    
    def cacher
      @cacher ||= CacheController.new
    end

    #---------------
    
    def cache(*args)
      cacher.cache(*args)
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
