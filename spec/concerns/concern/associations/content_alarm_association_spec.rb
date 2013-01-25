require "spec_helper"

describe Concern::Associations::ContentAlarmAssociation do
  subject { build :test_class_story }
  
  #--------------------
  
  describe '#should_reject_alarm?' do
    it "rejects alarm is alarm doesn't exist and the fire_at fields are blank" do
      subject.alarm.should eq nil
      subject.should_reject_alarm?({"fire_at" => ""}).should eq true
    end
  end
  
  #--------------------
  
  describe "#should_destroy_alarm?" do
    it "is true if there was an alarm and status went from pending to not pending" do
      subject.alarm = create :content_alarm, :pending
      subject.stub(:status_changed?) { true }
      subject.stub(:status_was) { ContentBase::STATUS_PENDING }
      subject.should_destroy_alarm?.should eq true
    end
    
    it "is false if status was not pending" do
      subject.alarm = create :content_alarm, :pending
      subject.stub(:status_changed?) { true }
      subject.stub(:status_was) { ContentBase::STATUS_LIVE }
      subject.should_destroy_alarm?.should eq false
    end
    
    it "is false if status was not changed" do
      subject.alarm = create :content_alarm, :pending
      subject.stub(:status_changed?) { false }
      subject.should_destroy_alarm?.should eq false
    end
  end
  
  
  #--------------------
  
  describe "#destroy_alarm" do
    it "marks alarm for destruction" do
      subject.alarm = create :content_alarm, :pending
      subject.alarm.marked_for_destruction?.should eq false
      subject.destroy_alarm
      subject.alarm.marked_for_destruction?.should eq true
    end
  end
end
