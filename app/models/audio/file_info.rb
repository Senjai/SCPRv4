require 'open-uri'

class Audio
  module FileInfo
    # Compute duration via Mp3Info
    # Set to 0 if something goes wrong
    # so it's not considered "blank"
    def compute_duration
      return false if !audio_file_accessible?

      # If the file is available, just grab it and use it.
      # Otherwise we'll open the audio file over HTTP and
      # read it
      mp3_io = self.mp3? ? self.mp3.path : open(self.external_url)

      Mp3Info.open(mp3_io) do |file|
        self.duration = file.length
      end

      self.duration ||= 0
    end


    # Compute the size via Carrierwave
    # Set a value to 0 if something goes wrong
    # So that size won't be "blank"
    def compute_size
      return false if !audio_file_accessible?
      self.size = self.mp3.file.size # Carrierwave sets this to 0 if it can't compute it
    end


    # Compute duration and size, and save the object
    def compute_file_info!
      self.compute_duration
      self.compute_size
      self.save!
    end


    private

    def audio_file_accessible?
      self.mp3.present? || self.external_url.present?
    end
  end
end
