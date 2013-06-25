class ImageUploader < CarrierWave::Uploader::Base
  storage :file
  asset_host proc { Rails.application.config.scpr.media_url }
  

  def store_dir
    File.join(
      Rails.application.config.scpr.media_root, 
      "uploads", 
      "images", 
      model.class.name.underscore.pluralize, 
      model.id.to_s
    )
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
