require "spec_helper"

describe Concern::Methods::PublishingMethods do
  describe "#publishing?" do
    it "is true if status was changed and object is published" do
      story = create :test_class_story, :pending
      story.publishing?.should eq false

      story.status = ContentBase::STATUS_LIVE
      story.publishing?.should eq true
    end

    it "is false if status was not changed" do
      story = create :test_class_story, :published
      story.status = ContentBase::STATUS_LIVE
      story.publishing?.should eq false
    end

    it "is false if status was changed to something non-published" do
      story = create :test_class_story, :published
      story.status = ContentBase::STATUS_DRAFT
      story.publishing?.should eq false
    end
  end

  #--------------------

  describe "#unpublishing?" do
    it "is true if status was changed and object is not published" do
      story = create :test_class_story, :published
      story.unpublishing?.should eq false

      story.status = ContentBase::STATUS_DRAFT
      story.unpublishing?.should eq true
    end

    it "is false if status was not changed" do
      story = create :test_class_story, :draft
      story.status = ContentBase::STATUS_DRAFT
      story.unpublishing?.should eq false
    end

    it "is false if status was changed to published" do
      story = create :test_class_story, :draft
      story.status = ContentBase::STATUS_LIVE
      story.unpublishing?.should eq false
    end
  end
end
