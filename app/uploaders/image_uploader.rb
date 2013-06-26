class ImageUploader < CarrierWave::Uploader::Base
  storage :file
  asset_host Rails.application.config.scpr.media_url
  
  def url
    File.join(asset_host, public_image_path)
  end

  def store_dir
    File.join(Rails.application.config.scpr.media_root, public_image_path)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private

  def public_image_path
    File.join \
      "uploads", "images",
      model.class.name.underscore.pluralize,
      model.id.to_s
  end
end
