#
# EncoAudio
#
# Given enco_number and enco_date
#
class Audio
  class EncoAudio < Audio
    class << self
      def store_dir(audio)
        STORE_DIRS[:enco]
      end
  
      # Generate the filename for an object
      def filename(audio)
        date = audio.enco_date.strftime("%Y%m%d")
        "#{date}_features#{audio.enco_number}.mp3"
      end
  
      #------------

      #------------
      # Proxy to Audio::Sync::bulk_sync_awaiting_audio
      def bulk_sync
        Audio::Sync.bulk_sync_awaiting_audio(self)
      end
    end # singleton

    #------------
    
    def sync
      Audio::Sync.sync_if_file_exists(self)
    end
  end # EncoAudio
end # Audio
