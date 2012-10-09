##
# UploadedAudio 
#
# Uploaded via the CMS
# Doesn't need to be synced
#
class Audio
  class UploadedAudio < Audio
    def self.store_dir(audio)
      "#{STORE_DIRS[:upload]}/#{Time.now.strftime("%Y/%m/%d")}"
    end

    def self.filename(audio)
      audio.mp3.file.filename
    end
    
  end # UploadedAudio
end # Audio
