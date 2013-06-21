require 'spec_helper'

describe DistinctScheduleSlot do
  describe '::on_at' do
    it 'grabs slots on at the requested time' do
      t = Time.now

      old     = create :distinct_schedule_slot, starts_at: t.yesterday
      current = create :distinct_schedule_slot, starts_at: t-1.hour, ends_at: t+2.hours
      later   = create :distinct_schedule_slot, starts_at: t.tomorrow

      DistinctScheduleSlot.on_at(t).should eq [current]
    end
  end

  describe '::block' do
    it 'grabs a range of slots' do
      t = Time.now

      old     = create :distinct_schedule_slot, starts_at: t.yesterday
      current = create :distinct_schedule_slot, starts_at: t-1.hour, ends_at: t+2.hours
      later   = create :distinct_schedule_slot, starts_at: t.tomorrow

      DistinctScheduleSlot.block(t, 3.days).should eq [current, later]
    end
  end
end
