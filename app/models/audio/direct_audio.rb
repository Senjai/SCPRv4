##
# DirectAudio 
#
# Given an arbitrary path to an mp3
#
class Audio
  class DirectAudio < Audio
    def self.store_dir(audio)
      path = Pathname.new(audio.mp3_path)
      path.split.first.to_s
    end
  
    def self.filename(audio)
      path = Pathname.new(audio.mp3_path)
      path.split.last.to_s
    end
  
    #------------
  
    def self.sync!
      Audio::Sync.sync_awaiting_audio_if_file_exists!
    end
  end
end
