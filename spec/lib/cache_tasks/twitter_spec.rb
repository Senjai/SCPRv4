require "spec_helper"

describe CacheTasks::Twitter do
  describe "#run" do
    let(:task) { CacheTasks::Twitter.new('kpcc') }
    let(:tweets) { ["tweet1", "tweet2"] }
    
    it "doesn't do anything if tweets are blank" do
      Rails.cache.fetch("twitter:kpcc").should eq nil
      task.stub(:fetch) { false }
      task.run.should eq nil
      Rails.cache.fetch("twitter:kpcc").should eq nil
    end
    
    it "sends off to the #cache if tweets are present" do
      task.should_receive(:fetch).and_return(tweets)
      task.should_receive(:cache).with(tweets, "/shared/widgets/cached/tweets", "twitter:kpcc")
      task.run.should eq true
    end
  end
  
  #--------------------
  
  describe "#fetch" do
    let(:task) { CacheTasks::Twitter.new('kpcc') }
    let(:tweets) { ["tweet1", "tweet2"] }

    it "sends to Twitter#user_timeline" do
      ::Twitter::Client.any_instance.should_receive(:user_timeline).with('kpcc', CacheTasks::Twitter::DEFAULTS).and_return(tweets)
      task.fetch.should eq tweets
    end
    
    it "returns false on error" do
      ::Twitter::Client.any_instance.should_receive(:user_timeline).with('kpcc', CacheTasks::Twitter::DEFAULTS).and_raise(StandardError)
      task.fetch.should eq false
    end
  end
end
