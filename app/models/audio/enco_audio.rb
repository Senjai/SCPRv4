#
# EncoAudio
#
# Given enco_number and enco_date
#
class Audio
  class EncoAudio < Audio
    include Audio::Paths
    logs_as_task

    STORE_DIR       = "features"
    FILENAME_REGEX  = %r{(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_features(?<enco_id>\d{4})\.mp3} # 20121001_features1809.mp3

    SYNC_THRESHOLD = 2.weeks

    before_save :set_status


    class << self
      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      def default_status
        STATUS_WAIT
      end


      # This method is used by Job::SyncAudioJob
      def bulk_sync
        limit     = SYNC_THRESHOLD.ago
        synced    = 0

        awaiting  = self.awaiting_audio.where("created_at > ?", limit)

        if awaiting.empty?
          log "No Audio to sync."
          return false
        end

        awaiting.each do |audio|
          synced += 1 if audio.sync
        end

        log "Finished. Total synced: #{synced}"
      end

      add_transaction_tracer :bulk_sync, category: :task
    end # singleton



    def sync
      begin
        if File.exists? self.full_path
          self.mp3 = File.open(self.full_path)
          self.save!

          log "Saved Audio ##{self.id}: #{self.full_path}"
          self
        else
          log "Still awaiting audio file for Audio ##{self.id}: #{self.full_path}"
          false
        end
      rescue => e
        if Rails.env.test?
          raise e
        else
          log "Could not save Audio ##{self.id}: #{e}"
          return false
        end
      end
    end


    def store_dir
      STORE_DIR
    end

    def filename
      date = self.enco_date.strftime("%Y%m%d")
      "#{date}_features#{self.enco_number}.mp3"
    end


    private

    def set_status
      if self.mp3.present?
        self.status = STATUS_LIVE
      else
        self.status = STATUS_WAIT
      end
    end
  end # EncoAudio
end # Audio
