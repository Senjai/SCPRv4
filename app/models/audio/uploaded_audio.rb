##
# UploadedAudio 
#
# Uploaded via the CMS
# Doesn't need to be synced
#
class Audio
  class UploadedAudio < Audio
    include Audio::Paths

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
  end # UploadedAudio
end # Audio
