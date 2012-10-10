##
# Audio::SyncAudioJob
#
# Call `sync!` on the passed-in class
#
class Audio::SyncAudioJob
  @queue = "#{Rails.application.config.scpr.resque_queue}:syncaudio"
  
  def self.perform(klass)
    klass.constantize.sync!
  end
end
