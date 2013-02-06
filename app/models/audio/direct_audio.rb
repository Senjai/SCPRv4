##
# DirectAudio 
#
# Given an arbitrary path to an mp3
#
class Audio
  class DirectAudio < Audio
    class << self
      def store_dir(audio)
        path = Pathname.new(audio.mp3_path)
        path.split.first.to_s
      end
  
      # Generate the filename for an object
      def filename(audio)
        path = Pathname.new(audio.mp3_path)
        path.split.last.to_s
      end
    
      #------------
      # Proxy to Audio::Sync::bulk_sync_awaiting_audio
      def bulk_sync
        Audio::Sync.bulk_sync_awaiting_audio(self)
      end
    end # singleton
    
    def sync
      Audio::Sync.sync_if_file_exists(self)
    end
  end # DirectAudio
end # Audio
