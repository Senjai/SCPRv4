##
# Job::ComputeAudioFileInfo
#
# Get the duration and size of the file, and save
# The audio has to respond to #compute_duration and #compute_size
# Since these aren't defined on the Audio base class, you need to
# make sure they're defined in each subclass.
module Job
  class ComputeAudioFileInfo < Base
    @queue = "#{namespace}:compute_audio_file_info"

    class << self
      def perform(id)
        audio = Audio.find(id)

        if audio.mp3_file.present?
          audio.compute_duration if audio.duration.blank?
          audio.compute_size     if audio.size.blank?
          audio.save!

          log "Saved #{audio.class.name} ##{audio.id}. " \
              "Duration: #{audio.duration}; Size: #{audio.size}"
        else
          log "Audio isn't available for #{audio.class.name} ##{audio.id}."
        end
      end

      def on_failure(exception, id)
        log "Couldn't save audio file info for #{audio.class.name} ##{id}: " \
            "(#{exception.class}) #{exception}\n"
      end
    end # singleton
  end # ComputeAudioFileInfo
end # Job
