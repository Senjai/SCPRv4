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
  
      def sync!
        Audio::Sync.new(self).sync_awaiting_audio_if_file_exists!
      end
    end
  end
end
