require "spec_helper"

describe RemoteArticle do
  describe '::sync' do
    before :each do
      FakeWeb.register_uri(:get, %r|api\.npr|, 
        :content_type => "application/json",
        :body => load_fixture('api/npr/stories.json')
      )

      FakeWeb.register_uri(:get, %r|publish2|, 
        :content_type => "application/json",
        :body => load_fixture('api/chr/stories.json')
      )
    end

    it "syncs using each of the importers" do
      RemoteArticle.count.should eq 0
      RemoteArticle.sync
      RemoteArticle.count.should be > 0
    end
  end

  describe '#import' do
    before :each do
      FakeWeb.register_uri(:get, %r|api\.npr|, 
        :content_type => "application/json",
        :body => load_fixture('api/npr/story.json')
      )
    end

    it 'imports the article' do
      article = create :npr_article
      news_story = article.import

      # Just check a few things to make sure it's alright
      news_story.persisted?.should eq true
      news_story.assets.should be_present # the fixture has assets
    end
  end

  describe '#importer' do
    it 'is the importer module' do
      article = build :remote_article, source: "npr"
      article.importer.should eq NprArticleImporter
      article.source = "chr"
      article.importer.should eq ChrArticleImporter
    end
  end

  describe '#async_import' do
    it 'enqueues the import' do
      article = create :remote_article
      Resque.should_receive(:enqueue).with(Job::ImportRemoteArticle, article.id, "BlogEntry")

      article.async_import(import_to_class: "BlogEntry")
    end
  end
end
