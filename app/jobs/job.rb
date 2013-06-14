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

      def log(message, verbose=false)
        message = "*** #{message}"
        
        # Rails log and custom log always gets it
        Rails.logger.info message
        logger.info("***[#{Time.now}] #{self.name}: #{message}")
        
        # STDOUT only gets it if requested
        if !!ENV['VERBOSE'] || verbose
          $stdout.puts message
        end
      end

      #---------------
      
      def cache(*args)
        cacher.cache(*args)
      end


      private

      def logger
        @logger ||= Logger.new(Rails.root.join("log", "jobs.log"))
      end

      def cacher
        @cacher ||= CacheController.new
      end

      def timeout_retry(max_tries, &block)
        tries = 0
        begin
          yield
        rescue Faraday::Error::TimeoutError => e
          if tries < max_tries
            tries += 1
            logger.info "Trying again... (Try #{tries} of #{max_tries}"
            retry
          else
            raise e
          end
        end
      end
    end
    

    #---------------

    def log(*args)
      self.class.log(*args)
    end
  end
end
