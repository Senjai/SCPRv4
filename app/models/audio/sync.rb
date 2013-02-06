class Audio
  class Sync
    extend LogsAsTask
    logs_as_task
    
    class << self
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      #------------
      # Enqueue the sync task for any subclasses that need it
      def enqueue_all
        [Audio::ProgramAudio, Audio::DirectAudio, Audio::EncoAudio].each do |klass|
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
    
      #------------
      # Enco and Direct audio sync this way
      # Don't use this method directly, use object.sync
      def sync_if_file_exists(audio)
        begin
          if File.exists? audio.full_path
            audio.send :write_attribute, :mp3, audio.filename
            audio.save!
            self.log "Saved Audio ##{audio.id}: #{audio.full_path}"
            audio
          else
            self.log "Still awaiting audio file for Audio ##{audio.id}: #{audio.full_path}"
            false
          end
        rescue Exception => e
          self.log "Could not save Audio ##{audio.id}: #{e}"
          false
        end
      end

      add_transaction_tracer :bulk_sync_awaiting_audio, category: :task
    end # singleton
  end # Sync
end # Audio
