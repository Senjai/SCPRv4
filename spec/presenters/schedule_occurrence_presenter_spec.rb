require 'spec_helper'

describe ScheduleOccurrencePresenter do
  describe '#start_time' do
    it "recognizes midnight" do
      slot = build :schedule_occurrence, starts_at: Time.new(2013, 6, 24, 0)
      p    = presenter(slot)

      p.start_time.should eq 'midnight'
    end

    it 'recognizes noon' do
      slot = build :schedule_occurrence, starts_at: Time.new(2013, 6, 24, 12)
      p    = presenter(slot)

      p.start_time.should eq 'noon'
    end

    it 'hides the minutes if it is on the hour' do
      slot = build :schedule_occurrence, starts_at: Time.new(2013, 6, 24, 1, 0)
      p    = presenter(slot)

      p.start_time.should_not match /:00/
    end

    it "shows the minutes if it's off the hour" do
      slot = build :schedule_occurrence, starts_at: Time.new(2013, 6, 24, 1, 30)
      p    = presenter(slot)

      p.start_time.should match /:30/
    end
  end

  describe '#end_time' do
    it "is the same as start_time" do
      slot = build :schedule_occurrence, :recurring, ends_at: Time.new(2013, 6, 24, 12)
      p    = presenter(slot)

      p.end_time.should eq "noon"
    end
  end

  describe '#program_slug' do
    it "is the program slug if the program is present" do
      program = build :kpcc_program, slug: "blahblah"
      slot    = build :schedule_occurrence, :recurring, program: program
      p       = presenter(slot)

      p.program_slug.should eq 'blahblah'
    end

    it 'is nil if the program is not present' do
      slot = build :schedule_occurrence
      p    = presenter(slot)

      p.program_slug.should eq nil
    end
  end
end
