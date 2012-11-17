require "spec_helper"

describe Job::Homepage do
  describe "::perform" do
    it "makes a new task and runs it" do
      CacheTasks::Homepage.any_instance.should_receive(:run)
      Job::Homepage.perform("key")
    end
  end
end
