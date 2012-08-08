require "spec_helper"

describe CacheHelper do
  describe "archive_select" do
    it "yields if date is today" do
      date = Time.now.beginning_of_day
      view.should_not_receive(:content_cache)
      helper.archive_select(date, "anything") { "Yield" }.should eq "Yield"
    end
    
    it "yields if date is in future" do
      date = Time.tomorrow.beginning_of_day
      view.should_not_receive(:content_cache)
      helper.archive_select(date, "anything") { "Yield" }.should eq "Yield"
    end
    
    it "calls content_cache if time is in past" do
      date = Time.yesterday.beginning_of_day
      view.should_receive(:content_cache).and_return("content_cache")
      helper.archive_select(date, "anything") { "Yield" }.should eq "content_cache"
    end
  end
end
