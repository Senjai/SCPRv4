module RemoteStubs

  def load_response_fixture_file(name)
    path = "#{Rails.root}/spec/fixtures/#{name}"
    File.exists?(path) ? File.read(path) : nil
  end
  
end