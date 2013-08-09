##
# Job::SyncAudio
module Job
  class SyncAudio < Base
    @queue = "#{namespace}:rake_tasks"

    class << self
      def perform(klass)
        klass.constantize.bulk_sync
      end
    end # singleton
  end # SyncAudio
end # Job
