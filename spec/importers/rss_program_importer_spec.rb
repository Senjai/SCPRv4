require 'spec_helper'

describe RssProgramImporter do
  describe '::sync' do
    before :each do
      FakeWeb.register_uri(:get, %r{bbc\.co\.uk},
        :content_type   => 'text/xml',
        :body           => load_fixture('rss/rss_feed.xml')
      )
    end

    it "" do
    end
  end
end
