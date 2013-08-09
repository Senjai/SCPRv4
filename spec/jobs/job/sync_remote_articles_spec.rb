require 'spec_helper'

describe Job::SyncRemoteArticles do
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

  it "syncs the remote articles" do
    RemoteArticle.count.should eq 0
    Job::SyncRemoteArticles.perform
    RemoteArticle.count.should be > 0
  end
end
