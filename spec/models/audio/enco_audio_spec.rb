require "spec_helper"

describe Audio::EncoAudio do
  describe "::filename" do
    it "is makes the filename based on enco number and date" do
      audio = build :enco_audio, enco_number: "1234", enco_date: freeze_time_at("October 21, 1988")
      Audio::EncoAudio.filename(audio).should eq "19881021_features1234.mp3"
    end
  end
  
  #----------------
  
  describe "::store_dir" do
    it "is the predetermined enco folder" do
      stub_const("Audio::STORE_DIRS", { enco: "features" })
      audio = build :enco_audio
      Audio::EncoAudio.store_dir(audio).should eq "features"
    end
  end
  
  #----------------

  describe "::bulk_sync" do
    it "sends to Audio::Sync::bulk_sync_awaiting_audio" do
      Audio::Sync.should_receive(:bulk_sync_awaiting_audio).with(Audio::EncoAudio)
      Audio::EncoAudio.bulk_sync
    end
  end
  
  #----------------
  
  describe "#sync" do
    it "sends to Audio::Sync::sync_if_file_exists" do
      enco = create :enco_audio
      Audio::Sync.should_receive(:sync_if_file_exists).with(enco)
      enco.sync
    end
  end

  describe "#path" do
    it "returns the store_dir and the filename" do
      audio = create :audio, :enco
      audio.path.should eq "features/#{audio.filename}"
    end
  end

  #----------------

  describe "#full_path" do
    it "returns the server path to the mp3 if mp3 is present" do
      Rails.application.config.scpr.stub(:media_root) { Rails.root.join("spec/fixtures/media") }
      audio = create :audio, :enco
      audio.full_path.should eq Rails.root.join("spec/fixtures/media/audio/#{audio.path}").to_s

    end
  end

  #----------------

  describe "#url" do
    it "returns the full URL to the mp3 if it's live" do
      audio = create :audio, :enco, :live
      audio.url.should eq "#{Audio::AUDIO_URL_ROOT}/#{audio.path}"
    end

    it "returns nil if not live" do
      audio = create :audio, :enco
      audio.url.should be_nil
    end
  end

  describe "#podcast_url" do
    it "returns the full podcast URL to the mp3 if it's live" do
      audio = create :audio, :enco, :live
      audio.podcast_url.should eq "#{Audio::PODCAST_URL_ROOT}/#{audio.path}"
    end

    it "returns nil if mp3 not live" do
      audio = create :audio, :enco
      audio.podcast_url.should be_nil
    end
  end

end
