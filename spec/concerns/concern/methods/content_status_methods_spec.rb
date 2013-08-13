require "spec_helper"

# These specs also passively test the +status_text+ method.

describe Concern::Methods::ContentStatusMethods do
  describe "#killed?" do
    it "is true if status is ContentBase::STATUS_KILLED" do
      story = build :test_class_story, status: ContentBase::STATUS_KILLED
      story.killed?.should eq true
    end

    it "is false if status is not ContentBase::STATUS_KILLED" do
      story = build :test_class_story, status: ContentBase::STATUS_DRAFT
      story.killed?.should eq false
    end
  end

  #------------------------

  describe "#draft?" do
    it "is true if status is ContentBase::STATUS_DRAFT" do
      story = build :test_class_story, status: ContentBase::STATUS_DRAFT
      story.draft?.should eq true
    end

    it "is false if status is not ContentBase::STATUS_DRAFT" do
      story = build :test_class_story, status: ContentBase::STATUS_REWORK
      story.draft?.should eq false
    end
  end

  #------------------------

  describe "#awaiting_rework?" do
    it "is true if status is ContentBase::STATUS_REWORK" do
      story = build :test_class_story, status: ContentBase::STATUS_REWORK
      story.awaiting_rework?.should eq true
    end

    it "is false if status is not ContentBase::STATUS_REWORK" do
      story = build :test_class_story, status: ContentBase::STATUS_EDIT
      story.awaiting_rework?.should eq false
    end
  end

  #------------------------

  describe "#awaiting_edits?" do
    it "is true if status is ContentBase::STATUS_EDIT" do
      story = build :test_class_story, status: ContentBase::STATUS_EDIT
      story.awaiting_edits?.should eq true
    end

    it "is false if status is not ContentBase::STATUS_EDIT" do
      story = build :test_class_story, status: ContentBase::STATUS_PENDING
      story.awaiting_edits?.should eq false
    end
  end

  #------------------------

  describe "#pending?" do
    it "is true if status is ContentBase::STATUS_PENDING" do
      story = build :test_class_story, status: ContentBase::STATUS_PENDING
      story.pending?.should eq true
    end

    it "is false if status is not ContentBase::STATUS_PENDING" do
      story = build :test_class_story, status: ContentBase::STATUS_LIVE
      story.pending?.should eq false
    end
  end

  #------------------------

  describe "#published?" do
    it "is true if status is ContentBase::STATUS_LIVE" do
      story = build :test_class_story, status: ContentBase::STATUS_LIVE
      story.published?.should eq true
    end

    it "is false if status is not ContentBase::STATUS_LIVE" do
      story = build :test_class_story, status: ContentBase::STATUS_KILLED
      story.published?.should eq false
    end
  end

  describe '#status_text' do
    it 'returns the human-friendly status' do
      story = build :test_class_story, status: ContentBase::STATUS_LIVE
      story.status_text.should_not eq nil
    end
  end

  describe 'publish' do
    it 'sets the status to STATUS_LIVE' do
      story = build :test_class_story, status: ContentBase::STATUS_DRAFT
      story.save!
      story.published?.should eq false

      story.publish
      story.reload.published?.should eq true
    end
  end
end
