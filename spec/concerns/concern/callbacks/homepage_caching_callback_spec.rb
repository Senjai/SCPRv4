require 'spec_helper'

describe Concern::Callbacks::HomepageCachingCallback do
  describe '#should_enqueue_homepage_cache?' do
    it "is true if story is unpublishing" do
      story = create :test_class_story, :published
      story.status = ContentBase::STATUS_PENDING
      story.should_enqueue_homepage_cache?.should eq true
    end

    it "is true if publishing" do
      story = create :test_class_story, :pending
      story.status = ContentBase::STATUS_LIVE
      story.should_enqueue_homepage_cache?.should eq true
    end

    it "is false if unpublished" do
      story = create :test_class_story, :pending
      story.should_enqueue_homepage_cache?.should eq false
    end

    it "is false if unpublished even if changed significantly" do
      story = create :test_class_story, :pending
      story.short_headline = "Updated"
      story.should_enqueue_homepage_cache?.should eq false
    end

    it "is true if published and changed attributes are significant" do
      story = create :test_class_story, :published
      story.short_headline = "Updated"
      story.should_enqueue_homepage_cache?.should eq true
    end

    it "is true if there are non-significant and significant attributes mixed" do
      story = create :test_class_story, :published
      story.short_headline = "Updated"
      story.body = "Okedoke"
      story.should_enqueue_homepage_cache?.should eq true
    end

    it "is false if only non-significant attributes are updated" do
      story = create :test_class_story, :published
      story.body = "Updated"
      story.should_enqueue_homepage_cache?.should eq false
    end

    it "is false if no attributes were changed" do
      story = create :test_class_story, :published
      story.should_enqueue_homepage_cache?.should eq false
    end

    it "is true if only assets were changed" do
      story = create :test_class_story, :published
      story.should_enqueue_homepage_cache?.should eq false
      story.asset_json = "[{\"id\":32459,\"caption\":\"Caption\",\"position\":12}]"
      story.should_enqueue_homepage_cache?.should eq true
    end
  end

  describe '#enqueue_homepage_cache' do
    it "runs if should_enqueue_homepage_cache? is true" do
      story = build :test_class_story
      story.stub(:should_enqueue_homepage_cache?) { true }
      story.should_receive(:enqueue_homepage_cache)
      story.save!
    end

    it "does not run if should_enqueue_homepage_cache is false" do
      story = build :test_class_story
      story.stub(:should_enqueue_homepage_cache?) { false }
      story.should_not_receive(:enqueue_homepage_cache)
      story.save!
    end

    it "occurs if significant attributes changed" do
      story = build :test_class_story, short_headline: "Newsflash"
      story.should_receive(:enqueue_homepage_cache)
      story.save!
    end

    it "doesn't occur if no significant attributes changed" do
      story = create :test_class_story, short_headline: "Newsflash"
      story.should_not_receive(:enqueue_homepage_cache)
      story.headline = "Full Newsflash"
      story.save!
    end
  end
end
