require 'spec_helper'

describe ScheduleSlotPresenter do
  describe '#recurring?' do
    it 'is true for recurring_schedule_slot' do
      slot = build :recurring_schedule_slot
      p    = presenter(slot)

      p.recurring?.should eq true
    end
  end

  describe '#distinct?' do
    it 'is true for distinct_schedule_slot' do
      slot = build :distinct_schedule_slot
      p    = presenter(slot)

      p.distinct?.should eq true
    end
  end

  describe '#start_time' do
    it "recognizes midnight" do
      slot = build :distinct_schedule_slot, starts_at: Time.new(2013, 6, 24, 0)
      p    = presenter(slot)

      p.start_time.should eq 'midnight'
    end

    it 'recognizes noon' do
      slot = build :distinct_schedule_slot, starts_at: Time.new(2013, 6, 24, 12)
      p    = presenter(slot)

      p.start_time.should eq 'noon'
    end

    it 'hides the minutes if it is on the hour' do
      slot = build :distinct_schedule_slot, starts_at: Time.new(2013, 6, 24, 1, 0)
      p    = presenter(slot)

      p.start_time.should_not match /:00/
    end

    it "shows the minutes if it's off the hour" do
      slot = build :distinct_schedule_slot, starts_at: Time.new(2013, 6, 24, 1, 30)
      p    = presenter(slot)

      p.start_time.should match /:30/
    end
  end

  describe '#end_time' do
    it "is the same as start_time" do
      slot = build :recurring_schedule_slot, end_time: Time.new(2013, 6, 24, 12).second_of_week
      p    = presenter(slot)

      p.end_time.should eq "noon"
    end
  end

  describe '#program_slug' do
    it "is the program slug if the program is present" do
      program = build :kpcc_program, slug: "blahblah"
      slot    = build :recurring_schedule_slot, program: program
      p       = presenter(slot)

      p.program_slug.should eq 'blahblah'
    end

    it 'is nil if the program is not present' do
      slot = build :distinct_schedule_slot
      p    = presenter(slot)

      p.program_slug.should eq nil
    end
  end

  describe '#program' do
    it "is the program if recurring" do
      program = build :kpcc_program, slug: "blahblah"
      slot    = build :recurring_schedule_slot, program: program
      p       = presenter(slot)

      p.program.should eq program
    end

    it "is nil if not recurring" do
      slot = build :distinct_schedule_slot
      p    = presenter(slot)

      p.program.should eq nil
    end
  end
end
