# encoding: utf-8

class AudioUploader < CarrierWave::Uploader::Base
  storage :file
  
  #--------------
  # Override default CarrierWave config
  # to move files instead of copy them.
  # Don't do it in test environment so 
  # the fixtures stay in place.
  def move_to_cache
    Rails.env == 'test' ? false : true
  end
  
  def move_to_store
    Rails.env == 'test' ? false : true
  end

  #--------------  
  
  def store_dir
    File.join(Rails.application.config.scpr.media_root, "audio", model.store_dir)
  end
  
  #--------------
  
  def raw_value
    model.read_attribute mounted_as
  end

  #--------------
  # Only allow mp3's
  def extension_white_list
    %w{ mp3 }
  end
end
