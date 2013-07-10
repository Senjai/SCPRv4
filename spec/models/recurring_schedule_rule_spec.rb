require 'spec_helper'

describe RecurringScheduleRule do
  describe 'validations' do
    it "validates program presence, but also adds the program_obj_key to the errors" do
      rule = build :recurring_schedule_rule, program: nil, program_obj_key: nil
      rule.valid?.should eq false
      rule.errors.keys.should include :program_obj_key
    end

    it "adds time to errors if start_time or end_time blank" do
      rule = build :recurring_schedule_rule, start_time: nil
      rule.valid?.should eq false
      rule.errors.keys.should include :time
      rule.errors.keys.should include :start_time
    end
  end

  describe '::create_occurrences' do
    it "creates occurrences for all rules" do
      rules = create_list :recurring_schedule_rule, 3
      ScheduleOccurrence.destroy_all
      ScheduleOccurrence.count.should eq 0

      t = Time.new(2013, 1, 1)
      RecurringScheduleRule.create_occurrences(start_date: t, end_date: t + 1.week)
      ScheduleOccurrence.count.should be > 0
    end
  end

  describe 'changing the program' do
    it "changes all the occurrence's program as well" do
      rule = create :recurring_schedule_rule
      rule.schedule_occurrences.first.program.should eq rule.program

      another_program = create :kpcc_program
      rule.program = another_program
      rule.save!
      rule.schedule_occurrences(true).first.program.should eq another_program
    end
  end

  describe '#duration' do
    it "calculates the duration from start_time and end_time" do
      rule = build :recurring_schedule_rule, start_time: "09:00", end_time: "11:00"
      rule.duration.should eq 2.hours
    end

    it "is 0 if start time and end time not available" do
      rule = build :recurring_schedule_rule, start_time: "09:00", end_time: nil
      rule.duration.should eq 0
    end

    it 'can bridge over-night' do
      rule = build :recurring_schedule_rule, start_time: "23:00", end_time: "1:00"
      rule.duration.should eq 2.hours
    end
  end

  describe 'schedule' do
    let(:t) { Time.new(2013, 7, 1) } # There are 5 mondays in this month
    let(:rule) { build :recurring_schedule_rule }
    let(:schedule) { 
      ScheduleBuilder.build_schedule(
        :interval     => rule.interval,
        :days         => rule.days,
        :start_time   => rule.start_time,
        :end_time     => rule.end_time
      )
    }
    
    it "sets the schedule to the passed-in Schedule object to_hash" do
      rule.schedule = schedule

      # We have to check to_s since Schedule doesn't have a custom
      # comparison method defined and will fail if they're not the 
      # same object (they won't be sincle #schedule uses Schedule#from_hash)
      rule.schedule.to_s.should eq schedule.to_s
    end
  end

  describe '#build_schedule' do
    it "builds a new schedule on create" do
      rule = build :recurring_schedule_rule
      rule.schedule.should eq nil

      rule.save!
      rule.schedule.should_not eq nil
    end

    it "builds a new schedule on save if rule changed" do
      rule = build :recurring_schedule_rule
      rule.save!
      original_schedule = rule.schedule

      rule.days = [1, 3, 4]
      rule.save!
      rule.schedule.should_not eq original_schedule
    end
  end

  describe '#build_occurrences' do
    let(:t) { Time.new(2013, 7, 1) } # There are 5 mondays in this month
    let(:rule) { 
      build :recurring_schedule_rule, 
      :days         => [1],
      :start_time   => "0:00",
      :end_time     => "1:00"
    }

    before :each do
      Time.stub(:now) { t }
      rule.build_schedule
    end

    it "runs on create if schedule_occurrences is blank" do
      rule.schedule_occurrences.should be_blank
      rule.save!
      rule.schedule_occurrences.should be_present
    end

    it "doesn't run if schedule_occurrences is present" do
      rule.build_occurrences
      rule.should_not_receive(:build_occurrences)
      rule.save!
    end

    it "uses the passed-in start_date if present" do
      rule.build_occurrences(start_date: t + 1.month)
      rule.schedule_occurrences.first.starts_at.should be >= t + 1.month
    end

    it "uses Time.now by default" do
      # Stub Time.now since build_occurrences uses it directly.
      # Actually, IceCube::Schedule#next_occurrence uses it by default.
      # Actually, IceCube::TimeUtil.now uses it directly.
      #
      # Since we're passing `nil` into `next_occurrence`, we want to stub
      # Time.now to use something with minute 0 and second 0,
      # because we're not specifying the minute or second in the rule.
      # If we don't do this, it will use the current minute/second,
      # which is annoying but whatever.
      rule.build_occurrences

      rule.schedule_occurrences.first.starts_at.should eq t
    end

    it "only builds up to the end_date" do
      rule.build_occurrences(start_date: t, end_date: t+1.week)
      rule.schedule_occurrences.after(t + 1.week).should eq []
    end

    it "sets the ends_at of the occurrence to starts_at + duration" do
      rule.build_occurrences
      rule.schedule_occurrences.first.duration.should eq 1.hour
    end

    it "doesn't duplicate already-existing occurrences" do
      rule.save!
      rule.schedule_occurrences.count.should eq 5

      rule.create_occurrences(start_date: t)
      rule.schedule_occurrences.count.should eq 5

      rule.create_occurrences(start_date: t, end_date: t+5.weeks)
      rule.schedule_occurrences.count.should eq 6
    end

    it "rebuilds if requested" do
      rule.save!
      rule.schedule_occurrences.count.should eq 5

      rule.create_occurrences(rebuild: true)
      rule.schedule_occurrences.count.should eq 5
    end
  end

  describe '#create_occurrences' do
    it 'builds occurrences and then saves' do
      Time.stub(:now) { Time.new(2013, 7, 1) }

      rule = create :recurring_schedule_rule, 
      :days         => [1],
      :start_time   => "0:00",
      :end_time     => "1:00"

      rule.schedule_occurrences.destroy_all

      rule.schedule_occurrences.count.should eq 0
      rule.create_occurrences
      rule.reload.schedule_occurrences.count.should eq 5
    end
  end
end
