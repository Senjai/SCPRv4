require "spec_helper"

describe ScheduleSlot do
  describe "::on_at" do
    it "gives distinct slots precedence" do
      t = Time.now

      recurring_current = create :recurring_schedule_slot, start_time: (t-1.hour).second_of_week, end_time: (t+2.hours).second_of_week
      distinct_current  = create :distinct_schedule_slot, starts_at: t-1.hour, ends_at: t+2.hours

      ScheduleSlot.on_at(t).should eq distinct_current
    end

    it 'returns the recurring slot if no distinct slot is available' do
      t = Time.now

      recurring_current = create :recurring_schedule_slot, start_time: (t-1.hour).second_of_week, end_time: (t+2.hours).second_of_week

      ScheduleSlot.on_at(t).should eq recurring_current
    end
  end
  
  #------------
  
  describe "::block" do
    it 'grabs the slots for the requested range of time' do
      t = Time.now

      recurring_old = create :recurring_schedule_slot, start_time: t.yesterday.second_of_week, end_time: (t.yesterday+2.hours).second_of_week
      distinct_old  = create :distinct_schedule_slot, starts_at: t.yesterday

      recurring_current = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t+2.hours).second_of_week
      distinct_current  = create :distinct_schedule_slot, starts_at: t-1.hour, ends_at: t+2.hours

      recurring_later = create :recurring_schedule_slot, start_time: (t.tomorrow-1.hour).second_of_week, end_time: (t.tomorrow+2.hours).second_of_week
      distinct_later  = create :distinct_schedule_slot, starts_at: t.tomorrow

      ScheduleSlot.block(t, 2.days).should eq [distinct_current, recurring_current, recurring_later, distinct_later]
    end
  end

  #------------

  describe "#next" do
    it "selects the slot immediately following this one" do
      t = Time.new(2012, 10, 21, 12)
      slot1 = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t + 2.hours).second_of_week
      slot2 = create :recurring_schedule_slot, start_time: (t + 2.hours).second_of_week, end_time: (t + 4.hours).second_of_week
      slot1.next.should eq slot2
    end
  end

  #------------

  describe "#json" do
    it "is a thing, which does stuff" do
      slot = create :recurring_schedule_slot
      slot.to_json.should be_present
    end
  end
end
