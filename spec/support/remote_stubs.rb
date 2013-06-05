module RemoteStubs
  def load_fixture(name)
    path = "#{Rails.root}/spec/fixtures/#{name}"
    File.read(path)
  end

  def load_audio_fixture(name)
    path = File.open(Rails.application.config.scpr.media_root.join(name))
    File.open(path)
  end
end
