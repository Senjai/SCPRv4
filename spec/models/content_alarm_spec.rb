require "spec_helper"

describe ContentAlarm do
  describe "scopes" do
    describe "pending" do
      it "selects those with pending status" do
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

  describe "::fire_pending" do
    it "fires any pending alarms" do
      story1 = create :test_class_story, :pending
      story2 = create :test_class_story, :pending

      pending       = create :content_alarm, :pending, content: story1
      other_pending = create :content_alarm, :pending, content: story2

      story1.published?.should eq false
      story2.published?.should eq false

      ContentAlarm.fire_pending

      story1.reload.published?.should eq true
      story2.reload.published?.should eq true
    end

    it "does not fire future alarms" do
      story = create :test_class_story, :pending
      not_pending = create :content_alarm, :future, content: story

      ContentAlarm.fire_pending

      story.reload.published?.should eq false
    end
  end

  #---------------------

  describe "#fire" do
    it 'publishes the content if it is pending' do
      story = create :test_class_story, :pending
      alarm = create :content_alarm, :pending, content: story
      story.reload.published?.should eq false

      alarm.fire
      story.reload.published?.should eq true
    end

    it 'does not publish the content if it is not pending' do
      story = create :test_class_story, :draft
      alarm = create :content_alarm, :pending, content: story
      story.reload.published?.should eq false

      alarm.fire
      story.reload.published?.should eq false
    end

    it "destroys itself after firing" do
      story = create :test_class_story, :published
      alarm = create :content_alarm, :pending, content: story

      alarm.fire
      alarm.destroyed?.should eq true
    end
  end

  #---------------------

  describe "#pending?" do
    it "is true if fire_at is now or past" do
      alarm = build :content_alarm, :pending
      alarm.pending?.should eq true
    end

    it "is false if fired_at is future" do
      alarm = build :content_alarm, :future
      alarm.pending?.should eq false
    end
  end
end
