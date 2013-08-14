require 'spec_helper'

describe Audio::FileInfo do
  describe "#compute_duration" do
    it "returns false if mp3 is blank" do
      audio = create :test_class_fake_audio
      audio.stub(:mp3_file)
      audio.compute_duration.should eq false
    end

    it "sets and returns the duration" do
      # The fake audio class uses the 2sec audio file
      audio = create :test_class_fake_audio
      audio.compute_duration
      audio.duration.should eq 2
    end

    it "sets to 0 if Mp3Info can't set the duration" do
      audio = create :test_class_fake_audio
      audio.duration.should eq nil
      Mp3Info.should_receive(:open)
      audio.compute_duration
      audio.duration.should eq 0
    end
  end

  #----------------

  describe "#compute_size" do
    it "returns false if mp3 is blank" do
      audio = create :test_class_fake_audio
      audio.stub(:mp3_file)
      audio.compute_size.should eq false
    end

    it "sets the size" do
      audio = create :test_class_fake_audio
      audio.size.should eq nil
      audio.mp3_file.size.should > 0
      audio.compute_size
      audio.size.should eq audio.mp3_file.size
    end
  end
end
