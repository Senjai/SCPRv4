require "spec_helper"

describe Concern::Associations::ContentAlarmAssociation do
  describe '#should_reject_alarm?' do
    it "rejects alarm is alarm doesn't exist and the fire_at fields are blank" do
      story = build :test_class_story
      story.alarm.should eq nil

      # Is there a better way to test this? 
      story.send(:should_reject_alarm?, {"fire_at" => ""}).should eq true
    end
  end

  #--------------------

  describe 'destroying an alarm' do
    it 'destroys the alarm if there was an alarm we went from pending to not pending' do
      story         = build :test_class_story, :pending
      story.alarm   = build :content_alarm, :pending
      story.save!

      story.reload.alarm.should be_present
      story.update_attribute(:status, ContentBase::STATUS_LIVE)
      story.reload.alarm.should eq nil
    end

    it "doesn't destroy the alarm if status is still pending" do
      story         = build :test_class_story, :pending
      story.alarm   = build :content_alarm, :pending
      story.save!

      story.reload.alarm.should be_present
      story.update_attribute(:status, ContentBase::STATUS_PENDING)
      story.reload.alarm.should be_present
    end

    it "destroys the alarm if fire_at was set to nil" do
      story         = build :test_class_story, :pending
      story.alarm   = build :content_alarm, :pending
      story.save!

      story.reload.alarm.should be_present
      story.alarm.fire_at = nil
      story.save!

      story.reload.alarm.should eq nil
    end

    it "doesn't destroy the alarm if fire_at is changed" do
      story         = build :test_class_story, :pending
      story.alarm   = build :content_alarm, :pending
      story.save!

      story.reload.alarm.should be_present
      story.alarm.fire_at = Time.now.tomorrow
      story.save!

      story.reload.alarm.should be_present
    end
  end
end
