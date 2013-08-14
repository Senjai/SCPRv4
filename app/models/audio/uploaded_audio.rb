##
# UploadedAudio 
#
# Uploaded via the CMS
# Doesn't need to be synced
#
class Audio
  class UploadedAudio < Audio
    include Audio::Paths
    include Audio::FileInfo

    STORE_DIR = "upload"

    class << self
      def default_status
        STATUS_LIVE
      end
    end # singleton


    def store_dir
      time = self.created_at.present? ? self.created_at : Time.now

      File.join \
        STORE_DIR,
        time.strftime("%Y"),
        time.strftime("%m"),
        time.strftime("%d")
    end


    def filename
      self.mp3.file.filename
    end

    def mp3_file
      self.mp3.file.file
    end
  end # UploadedAudio
end # Audio
