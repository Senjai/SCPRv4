require "spec_helper"

describe Audio::DirectAudio do
  describe '#url' do
    it "is just the specified external_url" do
      audio = build :direct_audio, external_url: "http://scpr.org/wat.mp3"
      audio.url.should eq "http://scpr.org/wat.mp3"
    end
  end

  describe '#podcast_url' do
    it "is just the specified external_url" do
      audio = build :direct_audio, external_url: "http://scpr.org/wat.mp3"
      audio.podcast_url.should eq "http://scpr.org/wat.mp3"
    end
  end

  describe "setting the status" do
    it "gets set to LIVE on save" do
      audio = create :direct_audio, status: nil
      audio.status.should eq Audio::STATUS_LIVE
    end
  end

  describe '#path' do
    it 'is nil' do
      audio = build :direct_audio
      audio.path.should eq nil
    end
  end

  describe '#full_path' do
    it 'is nil' do
      audio = build :direct_audio
      audio.full_path.should eq nil
    end
  end

  describe '#store_dir' do
    it 'is nil' do
      audio = build :direct_audio
      audio.store_dir.should eq nil
    end
  end

  describe '#filename' do
    it 'is is the filename' do
      audio = build :direct_audio, external_url: "http://npr.org/audio/wat.mp3"
      audio.filename.to_s.should eq "wat.mp3"
    end
  end

  describe '#mp3_file' do
    before :each do
      FakeWeb.register_uri(:get, %r{audio\.com},
        content_type: 'audio/mpeg',
        body: load_fixture('media/audio/2sec.mp3'))
    end

    it 'opens the file' do
      audio = build :direct_audio, external_url: 'http://audio.com/wat.mp3'
      audio.mp3_file.should be_a Tempfile
    end
  end

  describe '#compute_duration' do
    before :each do
      FakeWeb.register_uri(:get, %r{audio\.com},
        content_type: 'audio/mpeg',
        body: load_fixture('media/audio/2sec.mp3'))
    end

    it 'sets the duration' do
      audio = build :direct_audio, external_url: 'http://audio.com/wat.mp3'
      audio.compute_duration
      audio.duration.should eq 2
    end
  end

  describe '#compute_size' do
    before :each do
      FakeWeb.register_uri(:get, %r{audio\.com},
        content_type: 'audio/mpeg',
        body: load_fixture('media/audio/2sec.mp3'))
    end

    it 'sets the duration' do
      audio = build :direct_audio, external_url: 'http://audio.com/wat.mp3'
      audio.compute_size
      audio.size.should be > 0
    end
  end
end
