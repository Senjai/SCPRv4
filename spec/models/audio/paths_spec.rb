require 'spec_helper'

describe Audio::Paths do
  describe '#path' do
    it 'gets generated before save' do
      audio = build :test_class_fake_audio
      audio.path.should eq nil
      audio.save!

      audio.path.should eq "test_audio/123.mp3"
    end
  end

  describe "#full_path" do
    it "returns the server path to the mp3 if mp3 is present" do
      audio = create :test_class_fake_audio
      audio.full_path.should eq Rails.root.join("spec/fixtures/media/audio/#{audio.path}").to_s
    end
  end

  describe "#url" do
    it "returns the full URL to the mp3 if it's live" do
      audio = create :test_class_fake_audio, :live
      audio.url.should eq "#{Audio::AUDIO_URL_ROOT}/#{audio.path}"
    end

    it "returns nil if not live" do
      audio = create :test_class_fake_audio, :pending
      audio.url.should eq nil
    end
  end

  describe "#podcast_url" do
    it "returns the full podcast URL to the mp3 if it's live" do
      audio = create :test_class_fake_audio, :live
      audio.podcast_url.should eq "#{Audio::PODCAST_URL_ROOT}/#{audio.path}"
    end

    it "returns nil if mp3 not live" do
      audio = create :test_class_fake_audio, :pending
      audio.podcast_url.should eq nil
    end
  end
end
