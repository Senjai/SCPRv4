require 'spec_helper'

describe Job::ImportRemoteArticle do
    before :each do
      FakeWeb.register_uri(:get, %r|api\.npr|, 
        :content_type => "application/json",
        :body => load_fixture('api/npr/story.json')
      )
    end

  it "finds the article and imports it" do
    # This headline comes from the fixture
    # Setting the headline here is just for demonstration
    article = create :npr_article, headline: "Four Men In A Small Boat Face The Northwest Passage"
    Job::ImportRemoteArticle.perform(article.id, "NewsStory")

    story = NewsStory.all.first
    story.headline.should eq "Four Men In A Small Boat Face The Northwest Passage"
  end

  it "raises an error if the story isn't found" do
    article = create :npr_article, headline: "Four Men In A Small Boat Face The Northwest Passage"
    RemoteArticle.any_instance.stub(:import)

    expect { Job::ImportRemoteArticle.perform(article.id, "NewsStory") }.to raise_error
  end
end
