##
# Job::SyncAudio
module Job
  class SyncAudio < Base
    @queue = "#{namespace}:audio"

    class << self
      def perform(klass)
        klass.constantize.bulk_sync
      end
    end # singleton
  end # SyncAudio
end # Job
