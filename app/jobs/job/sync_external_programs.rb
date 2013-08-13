##
# SyncExternalPrograms
#
# Import all external programs.
#
module Job
  class SyncExternalPrograms < Base
    @queue = "#{namespace}:rake_tasks"

    class << self
      def perform
        ExternalProgram.sync
      end
    end
  end
end
