##
# Audio::SyncAudioJob
#
# Call `sync!` on the passed-in class
#
class Audio::SyncAudioJob
  @queue = "#{Rails.application.config.scpr.requeue_queue}:syncaudio"
  
  def self.perform(klass)
    klass.sync!
  end
end