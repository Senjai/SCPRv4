#
# EncoAudio
#
# Given enco_number and enco_date
#
class Audio
  class EncoAudio < Audio
    #------------
    # Sync ENCO audio on the server 
    # with the database    
    def self.store_dir(audio)
      STORE_DIRS[:enco]
    end
  
    def self.filename(audio)
      date = audio.enco_date.strftime("%Y%m%d")
      "#{date}_features#{audio.enco_number}.mp3"
    end
  
    #------------

    def self.sync!
      Audio::Sync.sync_awaiting_audio_if_file_exists!
    end
  end # EncoAudio
end # Audio
