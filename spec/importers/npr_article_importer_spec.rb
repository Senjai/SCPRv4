require 'spec_helper'

describe NprArticleImporter do
  describe '::sync' do
    before :each do
      FakeWeb.register_uri(:get, %r|api\.npr|, 
        :content_type => "application/json",
        :body => load_fixture('api/npr/stories.json')
      )
    end

    it 'builds cached articles from the API response' do
      NprArticleImporter.count.should eq 0
      added = NprArticleImporter.sync
      NprArticleImporter.count.should eq 2 # Two stories in the JSON fixture
      added.first.headline.should match /Small Boat/
    end
  end

  describe '#import' do
    before :each do
      FakeWeb.register_uri(:get, %r|api\.npr|, 
        :content_type => "application/json",
        :body => load_fixture('api/npr/story.json')
      )
    end

    it 'imports the bylines' do
      remote_article = create :npr_article
      news_story = NprArticleImporter.import(remote_article)
      news_story.bylines.first.name.should match /Scott Neuman/
    end

    it 'sets new to false for imported stories' do
      remote_article = create :npr_article
      NprArticleImporter.import(remote_article)
      remote_article[:is_new].should eq false
    end

    it 'adds in related links if an HTML link is available' do
      remote_article = create :npr_article
      news_story = NprArticleImporter.import(remote_article)
      news_story.related_links.first.url.should match /thetwo-way/
    end

    it "adds audio if it's available and if it gives stream rights" do
      remote_article = create :npr_article
      news_story = NprArticleImporter.import(remote_article)
      news_story.audio.size.should eq 1
      news_story.audio.first.url.should eq "http://pd.npr.org/anon.npr-mp3/npr/atc/2013/07/20130722_atc_07.mp3?orgId=1&topicId=1122&ft=3&f=204570329"
    end

    it "creates an asset if image is available" do
      remote_article = create :npr_article
      news_story = NprArticleImporter.import(remote_article)
      news_story.assets.size.should eq 1
      news_story.assets.first.caption.should match /European Space Agency/
    end
  end
end
