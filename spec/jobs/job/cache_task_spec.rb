require "spec_helper"

describe Job::CacheTask do
  describe "::perform" do
    it "runs the task!" do
      CacheTasks::Task.should_receive(:run)
      Job::CacheTask.perform("CacheTasks::Task")
    end
  end
end
