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
      # Sync ENCO audio on the server 
      # with the database
      def sync!
        Audio::Sync.new(self).sync_awaiting_audio_if_file_exists!
      end
    end # singleton
  end # EncoAudio
end # Audio
