##
# Audio::ComputeFileInfoJob
#
# Get the duration and size of the file, and save
#
class Audio::ComputeFileInfoJob
  @queue = Rails.application.config.scpr.resque_queue
  
  def self.perform(audio)
    audio.compute_duration
    audio.compute_size
    
    # If anything has thrown an error,
    # then save won't get called here, 
    # which is good.
    audio.save
  end
end