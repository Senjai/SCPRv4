#
# EncoAudio
#
# Given enco_number and enco_date
#
class Audio
  class EncoAudio < Audio
    include Audio::Paths

    STORE_DIR       = "features"
    FILENAME_REGEX  = %r{(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_features(?<enco_id>\d{4})\.mp3} # 20121001_features1809.mp3

    class << self
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      def default_status
        STATUS_WAIT
      end


      # This method is used by Job::SyncAudioJob
      def bulk_sync(limit=nil)
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

      add_transaction_tracer :bulk_sync, category: :task
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


    def store_dir
      STORE_DIR
    end

    def filename
      date = self.enco_date.strftime("%Y%m%d")
      "#{date}_features#{self.enco_number}.mp3"
    end
  end # EncoAudio
end # Audio
