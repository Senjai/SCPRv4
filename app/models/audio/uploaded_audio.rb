##
# UploadedAudio 
#
# Uploaded via the CMS
# Doesn't need to be synced
#
class Audio
  class UploadedAudio < Audio
    class << self
      def store_dir(audio=nil)
        "#{STORE_DIRS[:upload]}/#{Time.now.strftime("%Y/%m/%d")}"
      end

      def filename(audio)
        audio.mp3.file.filename
      end
    end # singleton
  end # UploadedAudio
end # Audio
