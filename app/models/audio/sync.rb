class Audio
  class Sync
    extend LogsAsTask
    logs_as_task
    
    class << self
      #------------
      # Enqueue the sync task for any subclasses that need it
      def enqueue_all
        [Audio::ProgramAudio, Audio::DirectAudio, Audio::EncoAudio].each do |klass|
          klass.enqueue_sync
        end
      end
    
      #------------
      # Run `#sync!` on all awaiting audio
      def bulk_sync_awaiting_audio!(klass, limit=nil)
        limit ||= 2.weeks.ago
        awaiting = klass.awaiting_audio.where("created_at > ?", limit)
            
        awaiting.each do |audio|
          audio.sync!
        end
      end
    
      #------------
      # Enco and Direct audio sync this way
      # Don't use this method directly, use object.sync!
      def sync_if_file_exists!(audio)
        synced = []
        begin
          if File.exists? audio.full_path
            audio.mp3 = File.open(audio.full_path)
            synced << audio.save!
            self.log "Saved Audio ##{audio.id}: #{audio.full_path}"
          else
            self.log "Still awaiting audio file for Audio ##{audio.id}: #{audio.full_path}"
          end
        rescue Exception => e
          self.log "Could not save Audio ##{audio.id}: #{e}"
        end
        
        self.log "Finished. Synced #{synced.size} files."
      end
    end # singleton
  end # Sync
end # Audio
