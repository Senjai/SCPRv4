require "spec_helper"

describe Audio::ComputeFileInfoJob do
  describe "::perform" do
    it "computes duration and size, and saves" do
      audio = create :audio, :uploaded
      Audio.any_instance.should_receive(:compute_duration)
      Audio.any_instance.should_receive(:compute_size)
      Audio.any_instance.should_receive(:save!)
      Audio::ComputeFileInfoJob.perform(audio)
    end
  end
end
