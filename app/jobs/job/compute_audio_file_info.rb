##
# Job::ComputeAudioFileInfo
#
# Get the duration and size of the file, and save
# The audio has to respond to #compute_duration and #compute_size
# Since these aren't defined on the Audio base class, you need to
# make sure they're defined in each subclass.
module Job
  class ComputeAudioFileInfo < Base
    @queue = "#{namespace}:audio"

    class << self
      def perform(id)
        audio = Audio.find(id)
        audio.compute_duration if audio.duration.blank?
        audio.compute_size     if audio.size.blank?
        audio.save!

        log "Saved Audio ##{audio.id}. " \
            "Duration: #{audio.duration}; Size: #{audio.size}"
      end

      def on_failure(exception, id)
        log "Couldn't save audio file info for Audio ##{id}: " \
            "(#{e.class}) #{e}\n" \
            "#{e.backtrace}"
      end
    end # singleton
  end # ComputeAudioFileInfo
end # Job
