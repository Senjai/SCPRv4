class Audio
  class Sync
    extend LogsAsTask
    logs_as_task

    class << self
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      #------------
      # Enqueue the sync task for any subclasses that need it
      def enqueue_all
        [Audio::ProgramAudio, Audio::EncoAudio].each do |klass|
          klass.enqueue_sync
        end
      end
    end # singleton
  end # Sync
end # Audio
