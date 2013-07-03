require 'spec_helper'

describe RecurringScheduleRule do
  describe 'setting the program' do
    it 'sets the program based on the object key' do
      program = create :kpcc_program
      slot = build :recurring_schedule_rule, program: nil
      slot.program_obj_key = program.obj_key
      slot.save!

      slot.program.should eq program
    end
  end

  describe '#build_occurrences' do
    let(:t) { Time.new(2013, 7, 1) } # There are 5 mondays in this month
    
    let(:rule) do
      create(:recurring_schedule_rule, 
        schedule: IceCube::Schedule.new { |s|
          s.rrule(IceCube::Rule.weekly.day(t.day).hour_of_day(t.hour))
        }
      )
    end

    it "uses the passed-in start_date if present" do
      rule.schedule_occurrences.size.should eq 0

      rule.build_occurrences(start_date: t)
      rule.schedule_occurrences.size.should eq 5
    end

    it "uses the last occurrence as the start_date if no start_date passed in" do
      rule.build_occurrences(start_date: t)
      rule.build_occurrences # Creates 5 occurrences

      # We want to make sure that the 6th start (the first occurrence of the second
      # group built above) is 1 week after the start of the 5th one (the last
      # occurrence of the first group). It's 1 week because we are using a weekly
      # rule.
      rule.schedule_occurrences[5].starts_at.should eq rule.schedule_occurrences[4].starts_at + 1.week
    end

    it "uses Time.now if there are no other occurrences" do
      # Stub Time.now since build_occurrences uses it directly.
      # Actually, IceCube::Schedule#next_occurrence uses it by default.
      # Actually, IceCube::TimeUtil.now uses it directly.
      #
      # Since we're passing `nil` into `next_occurrence`, we want to stub
      # Time.now to use something with minute 0 and second 0,
      # because we're not specifying the minute or second in the rule.
      # If we don't do this, it will use the current minute/second,
      # which is annoying but whatever.
      Time.stub(:now) { Time.new(2013, 7, 1) }
      rule.build_occurrences

      rule.schedule_occurrences.first.starts_at.should eq t + 1.week
    end

    it "only builds up to the end_date" do
      rule.build_occurrences(start_date: t, end_date: t+1.week)
      rule.schedule_occurrences.after(t + 1.week).should eq []
    end

    it "doesn't duplicate already-existing occurrences" do
      rule.build_occurrences(start_date: t)
      rule.schedule_occurrences.count.should eq 5

      rule.build_occurrences(start_date: t)
      rule.schedule_occurrences.count.should eq 5

      rule.build_occurrences(start_date: t, end_date: t+5.weeks)
      rule.schedule_occurrences.count.should eq 6
    end

    it "rebuilds if requested" do
      rule.build_occurrences(start_date: t)
      timestamp1 = rule.schedule_occurrences.first.created_at

      Time.stub(:now) { Time.new(1999, 6, 13) }
      rule.build_occurrences(start_date: t, rebuild: true)
      timestamp2 = rule.schedule_occurrences.first.created_at

      # What a dumb way to test this
      timestamp1.should_not eq timestamp2
    end
  end

  describe 
end
