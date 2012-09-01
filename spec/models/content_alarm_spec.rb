require "spec_helper"

describe ContentAlarm do
  it { should belong_to :content }
  
  describe "validations" do
    it { should validate_presence_of :fire_at }
    it { should validate_presence_of :content_type }
    it { should validate_presence_of :content_id }
  
    describe "fire_at_is_in_future" do
      it "validates that fire_at is in the future" do
        alarm = build :content_alarm, :pending # fired_at is in past
        alarm.save.should be_false
        alarm.errors.messages.keys.should include :fire_at
      end
    end
    
    describe "content_status_is_pending" do
      it "validates that content's status is set to pending" do
        content = create :news_story, status: ContentBase::STATUS_DRAFT
        alarm   = build :content_alarm, :future, content: content
        alarm.save.should be_false
        alarm.errors.messages.keys.should include :content_status
      end
    end
  end
  
  describe "set_action_for_django" do
    it "sets action before save to 'publish'" do
      alarm = build :content_alarm, :future
      alarm.action.should be_nil
      alarm.save!
      alarm.action.should eq 1
    end
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
  
  describe "ContentAlarm.fire_pending" do    
    it "fires all pending alarms" do
      ContentAlarm.any_instance.stub(:fire_at_is_in_future) { true }
      pending     = create_list :content_alarm, 2, :pending
      not_pending = create_list :content_alarm, 2, :future
      
      ContentAlarm.fire_pending
      ContentAlarm.pending.reload.should be_blank
      ContentAlarm.all.should eq not_pending
    end
  end
  
  #---------------------
  
  describe "fire" do
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
  
  describe "pending?" do
    let(:content) { create :news_story }
    
    it "is true if fire_at is now or past and has_fired is false" do
      alarm = build :content_alarm, :pending
      alarm.pending?.should be_true
    end
    
    it "is false if fired_at is future" do
      alarm = build :content_alarm, :future
      alarm.pending?.should be_false
    end
    
    it "is false if already fired and fired_at is future" do
      alarm = build :content_alarm, :future, has_fired: true
      alarm.pending?.should be_false
    end
  end
  
  #---------------------
  
  describe "can_fire?" do
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
