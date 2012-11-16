require "spec_helper"

describe CacheTasks::Task do
  describe "#cache" do
    it "Send off to CacheController" do
      task = CacheTasks::Task.new
      CacheController.any_instance.should_receive(:cache).with("some cool object", "some/cool/partial", "some:cool:key", local: :coolsym) { "The Cache" }
      task.cache("some cool object", "some/cool/partial", "some:cool:key", local: :coolsym)
    end
  end
  
  #------------
  
  describe "#enqueue" do
    it "uses Job::CacheTask if no class is passed in" do
      Resque.should_receive(:enqueue).with(Job::CacheTask, "CacheTasks::Task")
      CacheTasks::Task.new.enqueue
    end
    
    it "uses the passed-in class" do
      Resque.should_receive(:enqueue).with(Object, "CacheTasks::Task")
      CacheTasks::Task.new.enqueue(Object)
    end
  end
end
