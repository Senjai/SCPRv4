require 'spec_helper'

describe Job::SyncExternalPrograms do
  before :each do
    stub_request(:get, %r{podcast\.com}).to_return({
      :content_type   => 'text/xml',
      :body           => load_fixture('rss/rss_feed.xml')
    })
  end

  it "syncs the programs" do
    program = create :external_program, :from_rss, podcast_url: "http://podcast.com/podcast"
    Job::SyncExternalPrograms.perform
    program.external_episodes.should_not be_empty
  end
end
