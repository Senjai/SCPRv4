##
# Audio::SyncAudioJob
#
# Call `bulk_sync!` on the passed-in class
#
class Audio::SyncAudioJob
  @queue = "#{Rails.application.config.scpr.resque_queue}:syncaudio"
  
  def self.perform(klass)
    klass.constantize.bulk_sync!
  end
end
