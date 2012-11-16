##
# CacheTask
#
module Job
  class CacheTask < JobBase
    @queue = "#{namespace}:tasks"

    def self.perform(klass)
      klass.constantize.run
      self.log "Performed CacheTask for #{klass}"
    end
  end
end
