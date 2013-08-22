require "spec_helper"

describe Audio::EncoAudio do
  let(:real_file) { File.join(Audio::AUDIO_PATH_ROOT, "features/20121002_features1234.mp3") }
  let(:temp_file) { File.join(Audio::AUDIO_PATH_ROOT, "features/TEMPORARY.mp3") }

  describe "::bulk_sync" do
    it "only syncs audio from the past 2 weeks by default" do
      FileUtils.mv(real_file, temp_file)

      # Use live_enco so we know the file actually exists
      old_enco   = create :enco_audio, :live_enco, :awaiting
      new_enco   = create :enco_audio, :live_enco, :awaiting

      # Pretend this was created 4 weeks ago
      old_enco.update_column(:created_at, 4.weeks.ago)

      old_enco.live?.should eq false
      new_enco.live?.should eq false

      FileUtils.mv(temp_file, real_file)

      Audio::EncoAudio.bulk_sync

      # We have to reload because ::bulk_sync queries the database again
      old_enco.reload.live?.should eq false
      new_enco.reload.live?.should eq true
    end
  end

  describe "#sync" do
    it "sets status if the file exists" do
      # Move the mp3 out of the way to simulate awaiting audio
      FileUtils.mv(real_file, temp_file)

      enco = create :enco_audio, :live_enco, :awaiting
      enco.live?.should eq false

      # Move it back to simulate an audio file being uploaded to the server.
      FileUtils.mv(temp_file, real_file)

      enco.sync
      enco.live?.should eq true
    end

    it "doesn't do anything if the file doesn't exist" do
      # This enco information doesn't exist
      enco = create :enco_audio, :awaiting,
        enco_date: Date.new(2012, 10, 2), enco_number: "9999"

      enco.reload.live?.should eq false

      enco.sync
      enco.reload.live?.should eq false
    end
  end

  describe '#filename' do
    it "makes the filename based on enco number and date" do
      audio = build :enco_audio, enco_number: "1234", enco_date: Date.new(1988, 10, 21)
      audio.filename.should eq "19881021_features1234.mp3"
    end
  end

  describe '#store_dir' do
    it "is the predetermined enco folder" do
      audio = build :enco_audio
      audio.store_dir.should eq "features"
    end
  end

  describe '#mp3_file' do
    it "is the actual file if it exists" do
      enco = create :enco_audio, :live_enco
      enco.mp3_file.path.should eq File.open(real_file).path
    end

    it 'is nil if the file does not exist' do
      enco = create :enco_audio
      enco.mp3_file.should eq nil
    end
  end

  describe 'computing file info' do
    it 'computes the duration' do
      # Need to create it so the path gets set
      audio = create :enco_audio, :live_enco, :live
      audio.duration.should eq nil

      audio.compute_duration
      audio.duration.should eq 0 # it is the point1sec file
    end

    it 'computes the file size' do
      audio = create :enco_audio, :live_enco, :live
      audio.size.should eq nil

      audio.compute_size
      audio.size.should be > 0
    end
  end
end
