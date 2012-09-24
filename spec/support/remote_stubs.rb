module RemoteStubs
  def load_fixture(name)
    path = "#{Rails.root}/spec/fixtures/#{name}"
    File.exists?(path) ? File.read(path) : nil
  end
end
