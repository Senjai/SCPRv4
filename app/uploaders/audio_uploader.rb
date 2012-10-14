# encoding: utf-8

class AudioUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    File.join(Rails.application.config.scpr.media_root, "audio", model.store_dir)
  end
  
  def raw_value
    model.read_attribute mounted_as
  end

  def extension_white_list
    %w{ mp3 }
  end
end
