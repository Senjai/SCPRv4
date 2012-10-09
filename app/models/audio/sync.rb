class Audio
  class Sync
    extend LogsAsTask
    logs_as_task
  
    class << self
      #------------
      # Enqueue the sync task for any subclasses that need it
      def sync_each!
        [Audio::ProgramAudio, Audio::DirectAudio, Audio::EncoAudio].each do |klass|
          klass.enqueue_sync
        end
      end

      #------------
      # Enco and Direct audio sync this way
      # Don't use this method directly, use klass.sync!
      def sync_awaiting_audio_if_file_exists!
        Audio.awaiting_audio.each do |audio|
          begin
            if File.exists? audio.full_path
              audio.mp3 = File.open(audio.full_path)
              audio.save!
              self.log "Saved Audio ##{audio.id}: #{audio.full_path}"
            else
              self.log "Still awaiting audio file for Audio ##{audio.id}: #{audio.full_path}"
            end
          rescue Exception => e
            self.log "Could not save Audio ##{audio.id}: #{e}"
          end
        end
      end
    end
  end # Sync
end # Audio
