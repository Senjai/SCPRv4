#
# EncoAudio
#
# Given enco_number and enco_date
#
class Audio
  class EncoAudio < Audio
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
    include Audio::Paths
    include Audio::FileInfo

    logs_as_task

    STORE_DIR       = "features"
    FILENAME_REGEX  = %r{(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_features(?<enco_id>\d{4})\.mp3} # 20121001_features1809.mp3

    SYNC_THRESHOLD = 2.weeks

    # We want to set this on save so that it will associate immediately
    # when it's created if it exists.
    before_save :set_status


    class << self
      def default_status
        STATUS_WAIT
      end

      # This method is used by Job::SyncAudio
      def bulk_sync
        limit     = SYNC_THRESHOLD.ago
        awaiting  = self.awaiting_audio.where("created_at > ?", limit)
        awaiting.each(&:sync)
      end
    end # singleton


    def sync
      # The callback will set the status
      self.save!

      if self.live?
        log "Set #{self.class.name} ##{self.id} to Live: #{self.full_path}"
      else
        log "Still awaiting audio file for #{self.class.name} ##{self.id}: " \
            "#{self.full_path}"
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

    def mp3_file
      File.open(self.full_path) if mp3_exists?
    end


    private

    def set_status
      self.status = mp3_exists? ? STATUS_LIVE : STATUS_WAIT
    end

    def mp3_exists?
      File.exists?(self.full_path)
    end
  end # EncoAudio
end # Audio
