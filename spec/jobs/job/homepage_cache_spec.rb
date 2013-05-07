require "spec_helper"

describe Job::HomepageCache do
  describe "::perform" do
    it "scores and caches the homepage" do
      create :homepage, :published
      Homepage.any_instance.should_receive(:scored_content).and_return(Hash.new)
      Rails.cache.read("views/home/sections").should eq nil
      
      Job::HomepageCache.perform

      Rails.cache.read("home/sections").should_not eq nil
    end
  end
end
