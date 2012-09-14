require "spec_helper"

describe ContentAlarm do
  it { should belong_to :content }
  
  describe "validations" do
    it { should validate_presence_of :fire_at }
    it { should validate_presence_of :content_type }
    it { should validate_presence_of :content_id }
  end
  
  #---------------------
  
  describe "scopes" do
    describe "pending" do
      it "selects those with pending status" do
        ContentAlarm.any_instance.stub(:fire_at_is_in_future) { true }
        
        pending     = create :content_alarm, :pending
        not_pending = create :content_alarm, :future

        ContentAlarm.pending.should eq [pending]
      end
      
      it "orders by fire_at" do
        ContentAlarm.pending.to_sql.should match /order by fire_at/i
      end
    end
  end
  
  #---------------------
  
  describe "::generate" do    
    it "destroys an existing content_alarm for this object" do
      pending
      story = create :news_story, :pending
      story.alarm.should_receive(:destroy).once
      story.alarm.should be_a ContentAlarm
      ContentAlarm.generate(story)
    end
  end
  
  #---------------------
  
  describe "::fire_pending" do
    before :each do
      # Stub this so we can create content alarms with date in the past
      ContentAlarm.any_instance.stub(:fire_at_is_in_future) { true }
    end
    
    it "fires any pending alarms" do
      pending       = create :content_alarm, :pending
      other_pending = create :content_alarm, :pending
            
      pending_alarms = ContentAlarm.pending
      pending_alarms.sort.should eq [pending, other_pending].sort
      
      ContentAlarm.stub(:pending) { pending_alarms }
      pending_alarms.first.should_receive(:fire)
      pending_alarms.last.should_receive(:fire)
      
      ContentAlarm.fire_pending
    end
    
    it "does not fire future alarms" do
      not_pending = create :content_alarm, :future
      not_pending.should_not_receive(:fire)
      ContentAlarm.fire_pending
    end
  end
  
  #---------------------
  
  describe "#fire" do
    before :each do
      ContentAlarm.any_instance.stub(:fire_at_is_in_future) { true }
    end
    
    let(:alarm)   { create :content_alarm, :pending }
    
    it "returns false if can_fire? is false" do
      alarm.stub(:can_fire?) { false }
      alarm.fire.should be_false
    end
    
    it "returns self if can_fire? is true" do
      alarm.stub(:can_fire?) { true }
      alarm.fire.should eq alarm
    end
    
    it "destroys itself after successful fire" do
      alarm.fire
      alarm.destroyed?.should be_true
    end
  end

  #---------------------
  
  describe "#pending?" do
    let(:content) { create :news_story }
    
    it "is true if fire_at is now or past" do
      alarm = build :content_alarm, :pending
      alarm.pending?.should be_true
    end
    
    it "is false if fired_at is future" do
      alarm = build :content_alarm, :future
      alarm.pending?.should be_false
    end
  end
  
  #---------------------
  
  describe "#can_fire?" do
    let(:content) { create :news_story}
    it "is true if pending? and content status is pending" do
      content.status = ContentBase::STATUS_PENDING
      alarm          = build :content_alarm, :pending, content: content
      alarm.can_fire?.should be_true
    end
    
    it "is false if pending? is false" do
      content.status = ContentBase::STATUS_PENDING
      alarm          = build :content_alarm, :future, content: content
      alarm.can_fire?.should be_false
    end
    
    it "is false if content status is not pending" do
      content.status = ContentBase::STATUS_DRAFT
      alarm          = build :content_alarm, :pending, content: content
      alarm.can_fire?.should be_false
    end
    
    it "is false if content status is not pending and alarm is not pending" do
      content.status = ContentBase::STATUS_DRAFT
      alarm          = build :content_alarm, :future, content: content
      alarm.can_fire?.should be_false
    end
  end
end
