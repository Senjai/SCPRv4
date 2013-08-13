require 'spec_helper'

describe Job::SyncRemoteArticles do
  before :each do
    stub_request(:get, %r|api\.npr|).to_return({
      :content_type => "application/json",
      :body => load_fixture('api/npr/stories.json')
    })

    stub_request(:get, %r|publish2|).to_return({
      :content_type => "application/json",
      :body => load_fixture('api/chr/stories.json')
    })
  end

  it "syncs the remote articles" do
    RemoteArticle.count.should eq 0
    Job::SyncRemoteArticles.perform
    RemoteArticle.count.should be > 0
  end
end
