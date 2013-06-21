require "spec_helper"

describe Schedule do
  describe "::on_at" do
    it "grabs the slots for the requested time" do
      t = Time.now

      recurring_old = create :recurring_schedule_slot, start_time: t.yesterday.second_of_week, end_time: (t.yesterday+2.hours).second_of_week
      distinct_old  = create :distinct_schedule_slot, starts_at: t.yesterday

      recurring_current = create :recurring_schedule_slot, start_time: t.second_of_week, end_time: (t+2.hours).second_of_week
      distinct_current  = create :distinct_schedule_slot, starts_at: t-1.hour, ends_at: t+2.hours

      recurring_later = create :recurring_schedule_slot, start_time: t.tomorrow.second_of_week, end_time: (t.tomorrow+2.hours).second_of_week
      distinct_later  = create :distinct_schedule_slot, starts_at: t.tomorrow

      Schedule.on_at(t).should eq [distinct_current, recurring_current]
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

      Schedule.block(t, 2.days).should eq [distinct_current, recurring_current, recurring_later, distinct_later]
    end
  end
end
