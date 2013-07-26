##
# DirectAudio 
#
# Given an arbitrary URL to an mp3
#
class Audio
  class DirectAudio < Audio
    class << self
      def default_status
        STATUS_LIVE
      end
    end

    def url
      self.mp3_url
    end

    def podcast_url
      self.mp3_url
    end


    private

    def set_default_status
      self.status = STATUS_LIVE
    end
  end # DirectAudio
end # Audio
