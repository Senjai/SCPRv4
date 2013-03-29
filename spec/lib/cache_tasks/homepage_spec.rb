require "spec_helper"

describe CacheTasks::Homepage do
  describe "#run" do
    it "scores and caches the homepage" do
      create :homepage, :published
      Homepage.any_instance.should_receive(:scored_content).and_return(Hash.new)
      CacheTasks::Homepage.any_instance.should_receive(:cache).twice
      
      CacheTasks::Homepage.new.run
    end
  end
  
  #-----------------------
  
  describe "#enqueue" do
    it "send to resque with the obj_key" do
      Resque.should_receive(:enqueue).with(Job::Homepage)
      CacheTasks::Homepage.enqueue
    end
  end
end
