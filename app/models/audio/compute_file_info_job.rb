##
# Audio::ComputeFileInfoJob
#
# Get the duration and size of the file, and save
#
class Audio::ComputeFileInfoJob
  extend LogsAsTask
  logs_as_task
  
  @queue = Rails.application.config.scpr.resque_queue
  
  def self.perform(id)
    begin
      audio = Audio.find(id)
      audio.compute_duration
      audio.compute_size
      audio.save!
      self.log "Saved audio. Duration: #{audio.duration}; Size: #{audio.size}"
    rescue Exception => e
      self.log "Couldn't save audio file info: #{e}"
    end
  end
end
