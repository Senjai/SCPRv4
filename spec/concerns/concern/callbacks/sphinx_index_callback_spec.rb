require 'spec_helper'

describe Concern::Callbacks::SphinxIndexCallback do
  it "enqueues the index after save if attributes are changed" do
    story = build :test_class_story
    story.changed?.should eq true
    story.should_receive :enqueue_sphinx_index_for_class
    story.save!
  end

  it "doesn't enqueue index if not changed" do
    story = create :test_class_story
    story.changed?.should eq false
    story.should_not_receive :enqueue_sphinx_index_for_class
    story.save!
  end

  it 'sends off to Indexer with class name' do
    story = create :test_class_story
    Indexer.should_receive(:enqueue).with("TestClass::Story")
    story.headline = "Wat"
    story.save!
  end
end
