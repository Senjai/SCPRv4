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

    # Override these so it doesn't super up to Audio 
    # and cause a stack overflow.
    def path
      nil
    end

    def full_path
      nil
    end

    def store_dir
      nil
    end

    def filename
      @filename ||= Pathname.new(self.external_url).basename
    end


    def url
      self.external_url
    end

    def podcast_url
      self.external_url
    end
  end # DirectAudio
end # Audio
