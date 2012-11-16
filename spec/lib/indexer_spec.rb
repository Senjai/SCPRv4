require "spec_helper"

describe Indexer do
  describe "#index" do
    context "full index" do
      it "sends to ThinkingSphinx::Configuration.instance.controller#index with no arguments" do
        indexer = Indexer.new
        ThinkingSphinx::Configuration.instance.controller.should_receive(:index).with(no_args)
        indexer.index
      end
    end
    
    context "partial index" do
      it "sends to ThinkingSphinx::Configuration.instance.controller#index with an array of indexes" do
        BlogEntry.stub(:sphinx_index_names) { ["blog_entry_core"] }
        indexer = Indexer.new(BlogEntry)
        ThinkingSphinx::Configuration.instance.controller.should_receive(:index).with(["blog_entry_core"])
        indexer.index
      end
    end
  end
  
  #---------------------
  
  describe "#enqueue" do
    it "sends off to Indexer::IndexJob with an array of model names" do
      Resque.should_receive(:enqueue).with(Indexer::IndexJob, ["BlogEntry"])
      indexer = Indexer.new(BlogEntry)
      indexer.enqueue
    end
  end
  
  #---------------------
  
  describe "#models" do
    context "with models passed in" do
      it "is an array of classes" do
        indexer = Indexer.new(BlogEntry, NewsStory)
        indexer.models.should eq [BlogEntry, NewsStory]
      end
      
      it "ignores nils" do
        indexer = Indexer.new(BlogEntry, nil)
        indexer.models.should eq [BlogEntry]
      end
    end
    
    context "without models passed in" do
      it "is an empty array" do
        indexer = Indexer.new
        indexer.models.should eq []
      end
    end
  end
  
  #---------------------

  describe "#indexes" do
    context "with models passed in" do
      it "is an array of sphinx index names for the passed in models" do
        BlogEntry.stub(:sphinx_index_names) { ["blog_entry_core"] }
        NewsStory.stub(:sphinx_index_names) { ["news_story_core"] }
        indexer = Indexer.new(BlogEntry, NewsStory)
        indexer.indexes.should eq ["blog_entry_core", "news_story_core"]
      end
    end
    
    context "without arguments passed in" do
      it "is an empty array" do
        indexer = Indexer.new
        indexer.indexes.should eq []
      end
    end
  end
end

#-------------------

describe Indexer::IndexJob do
  describe "::perform" do
    it "constantizes the arguments and passed it off to Indexer" do
      indexer = Indexer.new(BlogEntry)
      Indexer.should_receive(:new).with(BlogEntry).and_return(indexer)
      indexer.should_receive(:index)
      Indexer::IndexJob.perform(["BlogEntry"])
    end
  end
end
