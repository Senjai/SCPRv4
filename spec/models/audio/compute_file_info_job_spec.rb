require "spec_helper"

describe Audio::ComputeFileInfoJob do
  describe "::perform" do
    it "computes duration and size, and saves" do
      audio = build :audio, :uploaded
      audio.should_receive(:compute_duration)
      audio.should_receive(:compute_size)
      audio.should_receive(:save)
      Audio::ComputeFileInfoJob.perform(audio)
    end
  end
end
