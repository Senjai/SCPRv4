module NewRelic
  class << self
    def with_manual_agent
      ENV['NEWRELIC_DISPATCHER'] ||= 'passenger'
      ::NewRelic::Agent.manual_start
      yield
      ::NewRelic::Agent.shutdown
    end
  end
end
