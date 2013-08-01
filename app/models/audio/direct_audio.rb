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
    def path
      nil
    end

    def full_path
      nil
    end

    def store_dir
      nil
    end


    def compute_duration
      return false if self.mp3_file.blank?

      Mp3Info.open(mp3) do |file|
        self.duration = file.length
      end

      self.duration ||= 0
    end

    def compute_size
      return false if self.mp3_file.blank?
      self.size = self.mp3_file.size
    end


    def filename
      @filename ||= Pathname.new(self.external_url).basename
    end


    def url
      self.external_url
    end

    def podcast_url
      self.external_url
    # Compute duration and size, and save the object
    def compute_file_info!
      self.compute_duration
      self.compute_size
      self.save!
    end


    def mp3_file
      @mp3_file ||= begin
        open(self.external_url)
      rescue
        nil
      end
    end
  end # DirectAudio
end # Audio
