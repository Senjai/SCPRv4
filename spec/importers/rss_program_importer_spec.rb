require 'spec_helper'

describe RssProgramImporter do
  describe '::sync' do
    before :each do
      stub_request(:get, %r{californiareport}).to_return({
        :content_type   => 'text/xml',
        :body           => load_fixture('rss/rss_feed.xml')
      })
    end

    it "imports episodes and enclosures as audio" do
      external_program = create :external_program, :from_rss
      RssProgramImporter.sync(external_program)
      external_program.external_episodes.should_not be_empty
      external_program.external_episodes(true).order("air_date").last.audio.first.url.should eq "http://downloads.bbc.co.uk/podcasts/worldservice/globalnews/globalnews_20130723-0200a.mp3"
    end

    it "doesn't import episodes that have already been imported" do
      external_program = create :external_program, :from_rss
      external_program.external_episodes.count.should eq 0
      RssProgramImporter.sync(external_program)
      count = external_program.external_episodes.count
      count.should_not eq 0

      RssProgramImporter.sync(external_program)
      external_program.external_episodes.count.should eq count
    end
  end
end
