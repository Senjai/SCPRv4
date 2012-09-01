require "spec_helper"

describe ContentAlarm do
  it { should belong_to :content }
  it { should validate_presence_of :fire_at }
  it { should validate_presence_of :content_type }
  it { should validate_presence_of :content_id }
  
  it "validates that fire_at is in the future" do
    alarm = build :content_alarm, :pending # fired_at is in past
    alarm.save.should be_false
    puts alarm.errors
  end
  
  it "sets action before save to 'publish'" do
    alarm = build :content_alarm, :future
    alarm.action.should be_nil
    alarm.save
    alarm.action.should eq "publish"
  end
  
  #---------------------
  
  describe "scopes" do
    describe "pending" do
      let(:content) { create :news_story }
      
      it "selects those with pending status" do
        pending     = create :content_alarm, :pending,  content: content
        not_pending = create :content_alarm, :future,   content: content
        fired       = create :content_alarm, :fired,    content: content
        
        ContentAlarm.pending.should eq [alarm]
      end
    end
  end
  
  #---------------------
  
  describe "ContentAlarm.fire_pending" do
    pending
  end
  
  #---------------------
  
  describe "fire" do
    it "returns false if can_fire? is false" do
      alarm = build :alarm, :future
      alarm.fire.should be_false
    end
    
    it "returns self if can_fire? is true" do
      alarm = build :alarm, :pending
      alarm.save(validate: false)
      alarm.fire.should eq alarm
    end
    
    it "destroys itself after successful fire" do
      Alarm.count.should eq 0
      alarm = build :alarm, :pending
      alarm.save(validate: false)
      Alarm.count.should eq 1
      alarm.fire
      alarm.destroyed?.should be_true
    end
  end

  #---------------------
  
  describe "pending?" do
    let(:content) { create :news_story }
    
    it "is true if fire_at is now or past and has_fired is false" do
      alarm = build :content_alarm, :pending, content: content
      alarm.pending?.should be_true
    end
    
    it "is false if already fired" do
      alarm = build :content_alarm, :fired
      alarm.pending?.should be_false
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
