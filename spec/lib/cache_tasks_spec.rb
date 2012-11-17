require "spec_helper"

describe CacheTasks::Task do
  describe "#cache" do
    it "Send off to CacheController" do
      task = CacheTasks::Task.new
      CacheController.any_instance.should_receive(:cache).with("some cool object", "some/cool/partial", "some:cool:key", local: :coolsym) { "The Cache" }
      task.cache("some cool object", "some/cool/partial", "some:cool:key", local: :coolsym)
    end
  end
end
