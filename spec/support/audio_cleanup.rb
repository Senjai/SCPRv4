module AudioCleanup
  def purge_uploaded_audio
    FileUtils.rm_rf Rails.application.config.scpr.media_root.join("audio/upload")
  end
end
