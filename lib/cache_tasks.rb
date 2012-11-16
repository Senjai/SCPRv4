$: << "."

module CacheTasks
  class Task
    attr_accessor :verbose
    
    def cacher
      @cacher ||= CacheController.new
    end
    
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

Dir["cache_tasks/*"].each { |f| require f }
