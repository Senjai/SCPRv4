require "spec_helper"

describe ExternalProgram do
  describe "scopes" do
    describe "active" do
      it "selects programs with online or onair status" do
        onair   = create :external_program, :from_rss, air_status: "onair"
        online  = create :external_program, :from_rss, air_status: "online"
        hidden  = create :external_program, :from_rss, air_status: "hidden"
        archive = create :external_program, :from_rss, air_status: "archive"
        ExternalProgram.active.sort.should eq [onair, online].sort
      end
    end
  end

  describe '::sync' do
    before :each do
      FakeWeb.register_uri(:get, %r{podcast\.com},
        :content_type   => 'text/xml',
        :body           => load_fixture('rss/rss_feed.xml')
      )
    end

    it "syncs the programs" do
      program = create :external_program, :from_rss, podcast_url: "http://podcast.com/podcast"
      Job::SyncExternalPrograms.perform
      program.external_episodes.should_not be_empty
    end
  end

  #-----------------

  describe '#published?' do
    it "is true if air_status is not hidden" do
      onair   = build :external_program, :from_rss, air_status: "onair"
      online  = build :external_program, :from_rss, air_status: "online"
      archive = build :external_program, :from_rss, air_status: "archive"

      onair.published?.should eq true
      online.published?.should eq true
      archive.published?.should eq true
    end

    it "is false if air_status is hidden" do
      hidden = build :external_program, :from_rss, air_status: "hidden"
      hidden.published?.should eq false
    end
  end

  describe '#importer' do
    it 'is the importer class based on source' do
      program = build :external_program, :from_npr
      program.importer.should eq NprProgramImporter
    end
  end

  describe '#sync' do
    context 'for npr' do
      before :each do
        FakeWeb.register_uri(:get, %r{api\.npr\.org},
          :content_type   => 'application/json',
          :body           => load_fixture('api/npr/program.json')
        )
      end

      it "syncs using the importer" do
        program = create :external_program, :from_npr
        program.sync
        program.external_episodes.should_not be_empty
        program.external_segments.should_not be_empty
      end
    end

    context 'for rss' do
      before :each do
        FakeWeb.register_uri(:get, %r{rss\.com},
          :content_type   => 'text/xml',
          :body           => load_fixture('rss/rss_feed.xml')
        )
      end

      it "syncs using the importer" do
        program = create :external_program, :from_rss, podcast_url: "http://rss.com"
        program.sync
        program.external_episodes.should_not be_empty
        program.external_segments.should be_empty
      end
    end
  end

  describe '#rss_url' do
    it 'is the RSS link if present' do
      program = build :external_program
      program.related_links.build(link_type: "rss", url: "http://rss.com", title: "wat")
      program.rss_url.should eq "http://rss.com"
    end

    it "is nil if no RSS link is present" do
      program = build :external_program
      program.rss_url.should eq nil
    end
  end

  describe '#to_program' do
    it 'turns it into a program' do
      program = build :external_program
      program.to_program.should be_a Program
    end
  end
end
