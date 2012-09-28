class AudioUploader < CarrierWave::Uploader::Base
  storage :file
  
  def extension_white_list
    %w{ mp3 }
  end
  
  def store_dir
    File.join Rails.application.config.scpr.media_root, "audio/upload", Time.now.strftime("%Y/%m/%d")
  end
end
