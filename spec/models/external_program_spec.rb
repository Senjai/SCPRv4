require "spec_helper"

describe ExternalProgram do

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:air_status) }

    context "validates rss_url or podcast_url are present" do
      it "allows only rss_url" do
        program = build :external_program, podcast_url: nil, rss_url: "cool-program-bro.com"
        program.should be_valid
      end

      it "allows only podcast_url" do
        program = build :external_program, podcast_url: "cool-podcast-bro.com", rss_url: ""
        program.should be_valid
      end

      it "allows both" do
        program = build :external_program, podcast_url: "cool-podcast-bro.com", rss_url: "cool-rss-bro.com"
        program.should be_valid
      end

      it "rejects if both blank" do
        program = build :external_program, podcast_url: "", rss_url: nil
        program.should_not be_valid
        program.errors.keys.sort.should eq [:base, :podcast_url, :rss_url].sort
      end
    end
  end

  #-----------------

  describe "scopes" do
    describe "active" do
      it "selects programs with online or onair status" do
        onair   = create :external_program, air_status: "onair"
        online  = create :external_program, air_status: "online"
        hidden  = create :external_program, air_status: "hidden"
        archive = create :external_program, air_status: "archive"
        ExternalProgram.active.sort.should eq [onair, online].sort
      end
    end
  end

  #-----------------

  describe "published?" do
    it "is true if air_status is not hidden" do
      onair   = build :external_program, air_status: "onair"
      online  = build :external_program, air_status: "online"
      archive = build :external_program, air_status: "archive"

      onair.published?.should eq true
      online.published?.should eq true
      archive.published?.should eq true
    end

    it "is false if air_status is hidden" do
      hidden = build :external_program, air_status: "hidden"
      hidden.published?.should eq false
    end
  end

  #-----------------

  describe "cache" do
    it "fetches and caches the podcast url if it's present" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { Feedzirra::Feed.parse(load_fixture("podcast.xml")) }
      program = build :external_program, podcast_url: "http://podcast.com/cool_podcast", rss_url: nil
      Rails.cache.fetch("ext_program:#{program.slug}:podcast").should eq nil
      program.cache
      Rails.cache.fetch("ext_program:#{program.slug}:podcast").should be_present
    end

    it "fetches and caches the rss url if it's present" do
      Feedzirra::Feed.stub!(:fetch_and_parse) { Feedzirra::Feed.parse(load_fixture("rss.xml")) }
      program = build :external_program, rss_url: "http://rss.com/cool_rss", podcast_url: nil
      Rails.cache.fetch("ext_program:#{program.slug}:rss").should eq nil
      program.cache
      Rails.cache.fetch("ext_program:#{program.slug}:rss").should be_present
    end
  end
end
