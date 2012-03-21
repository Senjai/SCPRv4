def load_xml_fixture_file(name)
  File.exists?("#{Rails.root}/spec/fixtures/#{name}.xml") ? File.read(path) : nil
end
