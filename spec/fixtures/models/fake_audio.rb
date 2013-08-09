module TestClass
  class FakeAudio < ActiveRecord::Base
    self.table_name = "test_class_fake_audio"
    include ::Audio::Paths

    def store_dir
      "test_audio"
    end

    def filename
      "123.mp3"
    end

    def live?
      self.status == 2
    end
  end
end
