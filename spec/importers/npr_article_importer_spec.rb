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
      NprArticle.count.should eq 0
      added = NprArticle.sync
      NprArticle.count.should eq 2 # Two stories in the JSON fixture
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
      news_story = remote_article.import
      news_story.bylines.first.name.should match /Scott Neuman/
    end

    it 'sets new to false for imported stories' do
      remote_article = create :npr_article
      remote_article.import
      remote_article[:is_new].should eq false
    end

    it 'adds in related links if an HTML link is available' do
      remote_article = create :npr_article
      news_story = remote_article.import
      news_story.related_links.first.url.should match /thetwo-way/
    end

    it "creates an asset if image is available" do
      remote_article = create :npr_article
      news_story = remote_article.import
      news_story.assets.size.should eq 1
      news_story.assets.first.caption.should match /European Space Agency/
    end
  end
end
