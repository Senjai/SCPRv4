require "spec_helper"

describe CacheTasks::Homepage do
  describe "#run" do
    it "sends off to different classes" do
      create :homepage, :published
      Indexer.any_instance.should_receive(:index)
      Homepage.any_instance.should_receive(:scored_content).and_return(Hash.new)
      CacheTasks::Homepage.any_instance.should_receive(:cache).twice
      
      CacheTasks::Homepage.new.run
    end
  end
  
  #-----------------------
  
  describe "#initialize" do
    it "sets the indexer to an Indexer with the model passed in, and ContentByline" do
      entry = create :blog_entry
      task = CacheTasks::Homepage.new(entry.obj_key)
      
      task.model.should eq BlogEntry
      task.indexer.models.should eq [BlogEntry, ContentByline]
    end
  end
  
  #-----------------------
  
  describe "#enqueue" do
    it "send to resque with the obj_key" do
      Resque.should_receive(:enqueue).with(Job::Homepage, "something")
      task = CacheTasks::Homepage.new("something")
      task.enqueue
    end
    
    it "can also have no object key" do
      Resque.should_receive(:enqueue).with(Job::Homepage, "")
      task = CacheTasks::Homepage.new
      task.enqueue
    end
  end
end
