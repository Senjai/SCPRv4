##
# Namespace for storing Resque jobs.
#
module Job
  class JobBase
    extend LogsAsTask
    logs_as_task
    
    private
    
    def self.namespace
      Rails.application.config.scpr.resque_queue
    end
  end
end
