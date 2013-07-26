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

      #------------
      # Run `#sync` on all awaiting audio
      def bulk_sync_awaiting_audio(klass, limit=nil)
        limit ||= 2.weeks.ago
        awaiting = klass.awaiting_audio.where("created_at > ?", limit)
        synced = 0

        if awaiting.empty?
          self.log "No Audio to sync."
        else

          awaiting.each do |audio|
            synced += 1 if audio.sync
          end

          self.log "Finished. Total synced: #{synced}"
        end
      end

      add_transaction_tracer :bulk_sync_awaiting_audio, category: :task
    end # singleton
  end # Sync
end # Audio
