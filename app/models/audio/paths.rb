# Methods for path and URL construction on audio.
# This should only be included into an Audio class for which we keep the
# file on our server. DirectAudio doesn't need it.
#
# The base class needs to define:
# * path, path=
# * live?
# * store_dir (for building `path`)
# * filename (for building `path`)
class Audio
  module Paths
    # The server path, 
    # eg. /home/kpcc/media/audio/features/20121001_features999.mp3
    def full_path
      @full_path ||= File.join(AUDIO_PATH_ROOT, self.path)
    end

    # The full URL to the live audio,
    # eg. http://media.scpr.org/audio/upload/2012/10/01/your_sweet_audio.mp3
    def url
      @url ||= File.join(AUDIO_URL_ROOT, self.path) if self.live?
    end

    # The full URL to the live podcast audio,
    # eg. http://media.scpr.org/podcasts/airtalk/20120928_airtalk.mp3
    def podcast_url
      @podcast_url ||= File.join(PODCAST_URL_ROOT, self.path) if self.live?
    end


    # This gets called by a callback in Audio on its typecasted class,
    # so we can't make it private or protected.
    def set_path
      self.path = File.join(self.store_dir, self.filename)
    end
  end
end
