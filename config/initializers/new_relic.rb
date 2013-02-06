module NewRelic
  class << self
    def with_manual_agent
      ENV['NEWRELIC_DISPATCHER'] ||= 'passenger'
      ::NewRelic::Agent.manual_start
      
      with_error_logging do
        yield
      end

      ::NewRelic::Agent.shutdown
    end

    #------------------

    def with_error_logging
      begin
        yield
      rescue => e
        log_error(e)
        ::NewRelic::Agent.shutdown
        raise e
      end
    end

    #------------------

    def log_error(e)
      NewRelic::Agent.agent.error_collector.notice_error(e)
    end
  end
end
