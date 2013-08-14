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

  describe '#mp3_file' do
    after :each do
      purge_uploaded_audio
    end

    it 'is the real, actual, no-fooling mp3 file' do
      audio = build :uploaded_audio
      audio.mp3_file.should eq audio.mp3.file.file
    end
  end

  describe 'computing file info' do
    after :each do
      purge_uploaded_audio
    end

    it 'computes the duration' do
      audio = build :uploaded_audio, mp3: File.open(File.join(Audio::AUDIO_PATH_ROOT, "2sec.mp3"))
      audio.duration.should eq nil

      audio.compute_duration
      audio.duration.should eq 2
    end

    it 'computes the file size' do
      audio = build :uploaded_audio, mp3: File.open(File.join(Audio::AUDIO_PATH_ROOT, "2sec.mp3"))
      audio.size.should eq nil

      audio.compute_size
      audio.size.should be > 0
    end
  end
end
