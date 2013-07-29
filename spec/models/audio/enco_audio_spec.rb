require "spec_helper"

describe Audio::EncoAudio do
  describe "::bulk_sync" do
    it "only syncs audio from the past 2 weeks by default" do
      # Set mp3 to nil so we can test the sync process
      old_enco   = create :enco_audio, :live_enco, mp3: nil
      new_enco   = create :enco_audio, :live_enco, mp3: nil
      old_enco.stub(:created_at) { 4.weeks.ago }

      old_enco.mp3.file.should eq nil
      new_enco.mp3.file.should eq nil

      Audio::EncoAudio.bulk_sync

      old_enco.mp3.file.should eq nil
      new_enco.mp3.should_not eq nil
    end
  end

  describe "#sync" do
    it "sets the mp3 and status if the file exists" do
      # Set status and mp3 to nil so we can check that this method sets them
      enco = create :enco_audio, :live_enco, status: nil, mp3: nil
      enco.mp3.file.should eq nil
      enco.status.should eq Audio::STATUS_WAIT

      enco.sync
      enco.mp3.file.should_not eq nil
      enco.status.should eq Audio::STATUS_LIVE
    end

    it "doesn't do anything if the file doesn't exist" do
      # This enco information doesn't exist
      enco = create :enco_audio, enco_date: Date.new(2012, 10, 2), enco_number: "9999"
      enco.mp3.file.should eq nil
      enco.status.should eq Audio::STATUS_WAIT

      enco.sync
      enco.mp3.file.should eq nil
      enco.status.should eq Audio::STATUS_WAIT
    end
  end

  describe '#filename' do
    it "makes the filename based on enco number and date" do
      audio = build :enco_audio, enco_number: "1234", enco_date: Date.new(1988, 10, 21)
      audio.filename.should eq "19881021_features1234.mp3"
    end
  end

  #----------------

  describe '#store_dir' do
    it "is the predetermined enco folder" do
      audio = build :enco_audio
      audio.store_dir.should eq "features"
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
      audio = create :audio, :enco
      audio.full_path.should eq Rails.root.join("spec/fixtures/media/audio/#{audio.path}").to_s

    end
  end

  #----------------

  describe "#url" do
    it "returns the full URL to the mp3 if it's live" do
      audio = create :enco_audio, :live_enco
      audio.url.should eq "#{Audio::AUDIO_URL_ROOT}/#{audio.path}"
    end

    it "returns nil if not live" do
      audio = create :enco_audio
      audio.url.should be_nil
    end
  end

  describe "#podcast_url" do
    it "returns the full podcast URL to the mp3 if it's live" do
      audio = create :enco_audio, :live_enco
      audio.podcast_url.should eq "#{Audio::PODCAST_URL_ROOT}/#{audio.path}"
    end

    it "returns nil if mp3 not live" do
      audio = create :enco_audio, :enco
      audio.podcast_url.should be_nil
    end
  end
end
