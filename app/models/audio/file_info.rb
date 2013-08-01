# Include this module into any audio source where the audio is Local.
# Uploaded Audio, ProgramAudio, and EncoAudio all match this criteria.
# DirectAudio should reimplement these methods to use the external URL.
class Audio
  module FileInfo
    # Compute duration via Mp3Info
    # Set to 0 if something goes wrong
    # so it's not considered "blank"
    def compute_duration
      return false if self.mp3.blank?

      Mp3Info.open(self.mp3.path) do |file|
        self.duration = file.length
      end

      self.duration ||= 0
    end


    # Compute the size via Carrierwave
    # Set a value to 0 if something goes wrong
    # So that size won't be "blank"
    def compute_size
      return false if self.mp3.blank?
      self.size = self.mp3.file.size # Carrierwave sets this to 0 if it can't compute it
    end
  end
end
