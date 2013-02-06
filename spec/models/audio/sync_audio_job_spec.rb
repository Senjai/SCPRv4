require "spec_helper"

describe Audio::SyncAudioJob do
  describe "::perform" do
    it "sends to klass.bulk_sync" do
      Audio.should_receive(:bulk_sync)
      Audio::SyncAudioJob.perform("Audio")
    end
  end
end
