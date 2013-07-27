require "spec_helper"

describe Audio::UploadedAudio do
  describe "::filename" do
    after :each do
      purge_uploaded_audio
    end

    it "is the mp3's actual filename" do
      audio = build :uploaded_audio
      audio.filename.should eq "point1sec.mp3"
    end
  end
  
  #----------------
  
  describe "#store_dir" do
    after :each do
      purge_uploaded_audio
    end

    it "uses Time.now for new records" do
      audio = build :uploaded_audio
      audio.store_dir.should eq "upload/#{Time.now.strftime('%Y/%m/%d')}"
    end

    it "uses the created_at timestamp if this is persisted" do
      audio = build :uploaded_audio
      audio.created_at = 1.week.from_now
      audio.store_dir.should eq "upload/#{1.week.from_now.strftime('%Y/%m/%d')}"
    end
  end

  describe '#path' do
    after :each do
      purge_uploaded_audio
    end

    it 'is the filename and the store dir' do
      audio = create :uploaded_audio
      audio.path.should eq "#{audio.store_dir}/#{audio.filename}"
    end
  end

  describe "#full_path" do
    after :each do
      purge_uploaded_audio
    end

    it "returns the server path to the mp3 if mp3 is present" do
      Rails.application.config.scpr.stub(:media_root) { Rails.root.join("spec/fixtures/media") }
      audio = create :uploaded_audio
      audio.full_path.should eq Rails.root.join("spec/fixtures/media/audio/#{audio.path}").to_s

    end
  end

  #----------------

  describe "#url" do
    after :each do
      purge_uploaded_audio
    end

    it "returns the full URL to the mp3 if it's live" do
      audio = create :uploaded_audio
      audio.url.should eq "#{Audio::AUDIO_URL_ROOT}/#{audio.path}"
    end
  end

  #----------------

  describe "#podcast_url" do
    after :each do
      purge_uploaded_audio
    end

    it "returns the full podcast URL to the mp3 if it's live" do
      audio = create :uploaded_audio
      audio.podcast_url.should eq "#{Audio::PODCAST_URL_ROOT}/#{audio.path}"
    end
  end
end
