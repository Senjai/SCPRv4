require 'spec_helper'

describe ChrArticleImporter do
  describe '::sync' do
    before :each do
      FakeWeb.register_uri(:get, %r|publish2|, 
        :content_type => "application/json",
        :body => load_fixture('api/chr/stories.json')
      )
    end

    it 'builds cached articles from the API response' do
      RemoteArticle.count.should eq 0
      added = ChrArticleImporter.sync
      RemoteArticle.count.should eq 2 # Two stories in the JSON fixture
      added.first.headline.should match /Obamacare/
    end
  end

  describe '#import' do
    before :each do
      FakeWeb.register_uri(:get, %r|publish2|, 
        :content_type => "application/json",
        :body => load_fixture('api/chr/story.json')
      )
    end

    it 'imports the bylines' do
      remote_article = create :chr_article
      news_story = ChrArticleImporter.import(remote_article)
      news_story.bylines.first.name.should match /Emily/
    end

    it 'sets new to false for imported stories' do
      remote_article = create :chr_article
      ChrArticleImporter.import(remote_article)
      remote_article[:is_new].should eq false
    end

    it 'adds in related links if an HTML link is available' do
      # Our fixture doesn't have an HTML link ... so just stub it.
      NPR::Story.any_instance.should_receive(:link_for).with('html').and_return('http://chr.com/story')
      
      remote_article = create :chr_article
      news_story = ChrArticleImporter.import(remote_article)
      news_story.related_links.should be_present
    end
  end
end
