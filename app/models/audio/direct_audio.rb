require 'open-uri'

##
# DirectAudio 
#
# Given an arbitrary URL to an mp3
#
class Audio
  class DirectAudio < Audio
    include Audio::FileInfo

    class << self
      def default_status
        STATUS_LIVE
      end
    end

    # Override these so it doesn't super up to Audio 
    # and cause a stack overflow.
    # Yes, this is terrible.
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


    def compute_duration
      return false if self.mp3_file.blank?

      Mp3Info.open(self.mp3_file) do |file|
        self.duration = file.length
      end

      self.duration ||= 0
    end

    def compute_size
      return false if self.mp3_file.blank?
      self.size = self.mp3_file.size || 0
    end


    def mp3_file
      @mp3_file ||= begin
        open(self.external_url)
      rescue
        nil
      end
    end


    # ugh, what have I gotten myself into...
    # What we need is a single Audio model with just the necessary
    # attrbutes - url, description, byline, timestamps, size, duration
    # - and some separate adapters which will take an input and turn
    # it into an Audio object. Right now we're just cramming all this
    # stuff into the Audio table and then not using 90% of it anywhere
    # else in the app.
    def set_path
      self.path = nil
    end
  end # DirectAudio
end # Audio
