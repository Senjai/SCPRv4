require "spec_helper"

describe Concern::Callbacks::CacheExpirationCallback do
  it "expires the object if it's already published" do
    story = create :test_class_story, :published
    Rails.cache.should_receive(:expire_obj).with(story)
    story.update_attributes(status: ContentBase::STATUS_LIVE, headline: "wat")
  end

  it "expires the object if it's unpublishing" do
    story = create :test_class_story, :published
    Rails.cache.should_receive(:expire_obj).with(story)
    story.update_attributes(status: ContentBase::STATUS_PENDING)
  end

  it "expires new keys if it's publishing" do
    story = create :test_class_story, :pending
    Rails.cache.should_receive(:expire_obj).with(story.class.content_key + ":new")
    Rails.cache.should_receive(:expire_obj).with("contentbase:new")
    story.update_attributes(status: ContentBase::STATUS_LIVE)
  end
end
