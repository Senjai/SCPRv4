# Include this module into any audio source where the audio is Local.
# Uploaded Audio, ProgramAudio, and EncoAudio all match this criteria.
# DirectAudio should reimplement these methods to use the external URL.
#
# Requires that the base class has:
# * mp3_file - the actual audio file
# * duration=
# * size=
class Audio
  module FileInfo
    # Compute duration via Mp3Info
    # Set to 0 if something goes wrong
    # so it's not considered "blank"
    def compute_duration
      return false if self.mp3_file.blank?

      Mp3Info.open(self.mp3_file) do |file|
        self.duration = file.length
      end

      self.duration ||= 0
    end


    # Compute the size via Carrierwave
    # Set a value to 0 if something goes wrong
    # So that size won't be "blank"
    def compute_size
      return false if self.mp3_file.blank?
      self.size = self.mp3_file.size || 0
    end
  end
end
