##
# Namespace for storing Resque jobs.
#
module Job
  class Base
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation


    class << self
      def namespace
        Rails.application.config.scpr.resque_queue
      end

      #--------------------

      def log(message)
        message = "*** #{message}"
        
        # Rails log and custom log always gets it
        Rails.logger.info message
        logger.info("***[#{Time.now}] #{self.name}: #{message}")
        
        # STDOUT only gets it if requested
        if @verbose
          $stdout.puts message
        end
      end

      #--------------------
      
      def logger
        @logger ||= Logger.new(Rails.root.join("log", "jobs.log"))
      end
    end


    #--------------------

    def log(*args)
      self.class.log(*args)
    end
  end
end
