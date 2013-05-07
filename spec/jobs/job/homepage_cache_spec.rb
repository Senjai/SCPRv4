require "spec_helper"

describe Job::HomepageCache do
  describe "::perform" do
    it "scores and caches the homepage" do
      create :homepage, :published
      Homepage.any_instance.should_receive(:scored_content).and_return(Hash.new)
      Job::HomepageCache.any_instance.should_receive(:cache).twice
      
      Job::HomepageCache.perform
    end
  end
end
