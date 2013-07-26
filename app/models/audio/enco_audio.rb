#
# EncoAudio
#
# Given enco_number and enco_date
#
class Audio
  class EncoAudio < Audio
    include Audio::Paths

    STORE_DIR = "features"

    class << self
      #------------
      # Proxy to Audio::Sync::bulk_sync_awaiting_audio
      def bulk_sync
        Audio::Sync.bulk_sync_awaiting_audio(self)
      end

      def default_status
        STATUS_WAIT
      end

      def bulk_sync_awaiting_audio(limit=nil)
        limit ||= 2.weeks.ago
        awaiting = self.awaiting_audio.where("created_at > ?", limit)
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
    end # singleton

    def sync
      begin
        if File.exists? self.full_path
          self.mp3 = self.full_path
          audio.save!
          self.log "Saved Audio ##{audio.id}: #{audio.full_path}"
          self
        else
          self.log "Still awaiting audio file for Audio ##{audio.id}: #{audio.full_path}"
          false
        end
      rescue => e
        self.log "Could not save Audio ##{audio.id}: #{e}"
        false
      end
    end

    add_transaction_tracer :sync, category: :task


    def store_dir
      STORE_DIR
    end

    def filename
      date = self.enco_date.strftime("%Y%m%d")
      "#{date}_features#{self.enco_number}.mp3"
    end
  end # EncoAudio
end # Audio
