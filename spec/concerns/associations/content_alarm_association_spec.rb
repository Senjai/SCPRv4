require "spec_helper"

describe Concern::Associations::ContentAlarmAssociation do
  subject { build :test_class_story }
  
  it { should have_one(:alarm).class_name("ContentAlarm").dependent(:destroy) }
  
  #--------------------
  
  describe '#should_generate_alarm?' do
    it "is true if the story is pending and published_at is present" do
      subject.status = ContentBase::STATUS_PENDING
      subject.published_at = Time.now.tomorrow
      
      subject.should_generate_alarm?.should eq true
    end
    
    it 'is false if not pending' do
      subject.status = ContentBase::STATUS_PUBLISHED
      subject.published_at = Time.now.tomorrow
      subject.should_generate_alarm?.should eq false
    end
    
    it 'is false if published_at not present' do
      subject.status = ContentBase::STATUS_PENDING
      subject.published_at = nil
      subject.should_generate_alarm?.should eq false
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

  #---------------------
  
  describe '#generate_alarm' do
    before :each do
      subject.status = ContentBase::STATUS_PENDING
    end
    
    it "generates an alarm if published_at is present" do
      subject.published_at = Time.now.tomomorrow
      subject.generate_alarm
      
      subject.alarm.should be_a ContentBase::ContentAlarm
      subject.alarm.fire_at.should eq subject.published_at
      subject.alarm.persisted?.should eq false
    end
    
    it "doesn't generate the alarm is published_at is blank" do
      subject.published_at = nil
      subject.generate_alarm
      
      subject.alarm.should eq nil
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
