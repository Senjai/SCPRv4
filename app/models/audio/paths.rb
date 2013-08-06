class Audio
  module Paths
    # The URL path, i.e. the path without "audio/"
    # eg. /upload/2012/10/01/your_sweet_audio.mp3
    def path
      @path ||= File.join(self.store_dir, self.filename)
    end

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
  end
end
