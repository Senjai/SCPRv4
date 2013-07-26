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
    end # singleton


    validate :enco_info_is_present_together

    def sync
      Audio::Sync.sync_if_file_exists(self)
    end


    def store_dir
      STORE_DIR
    end

    def filename
      date = self.enco_date.strftime("%Y%m%d")
      "#{date}_features#{self.enco_number}.mp3"
    end


    def sync_if_file_exists
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

    add_transaction_tracer :sync_if_file_exists, category: :task


    private

    def enco_info_is_present_together
      if self.enco_number.blank? ^ self.enco_date.blank?
        errors.add(:base,
          "Enco number and Enco date must both be present for ENCO audio")
        # Just so the form is aware that enco_number and enco_date are involved
        errors.add(:enco_number, "")
        errors.add(:enco_date, "")
      end
    end
  end # EncoAudio
end # Audio
