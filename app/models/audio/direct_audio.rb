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
      self.external_url
    end

    def podcast_url
      self.external_url
    end
  end # DirectAudio
end # Audio
