require "spec_helper"

describe ScheduleOccurrence do
  describe '::after' do
    it "gets occurrences after the requested date" do
      occurrence_early = create :schedule_occurrence, starts_at: Time.now.yesterday
      occurrence_later = create :schedule_occurrence, starts_at: Time.now.tomorrow

      ScheduleOccurrence.after(Time.now).should eq [occurrence_later]
    end
  end

  describe '::before' do
    it "gets occurrences before the requested date" do
      occurrence_early = create :schedule_occurrence, starts_at: Time.now.yesterday
      occurrence_later = create :schedule_occurrence, starts_at: Time.now.tomorrow

      ScheduleOccurrence.before(Time.now).should eq [occurrence_early]
    end
  end

  describe '::future' do
    it "gets occurrences after the now" do
      occurrence_early = create :schedule_occurrence, starts_at: Time.now.yesterday
      occurrence_later = create :schedule_occurrence, starts_at: Time.now.tomorrow

      ScheduleOccurrence.future.should eq [occurrence_later]
    end
  end

  describe '::past' do
    it "gets occurrences before now" do
      occurrence_early = create :schedule_occurrence, starts_at: Time.now.yesterday
      occurrence_later = create :schedule_occurrence, starts_at: Time.now.tomorrow

      ScheduleOccurrence.past.should eq [occurrence_early]
    end
  end

  describe '::between' do
    it 'gets any occurrence which airs between the start and end dates' do
      t = Time.new(2013, 6, 1)

      occurrence1 = create :schedule_occurrence, starts_at: t
      occurrence2 = create :schedule_occurrence, starts_at: t + 1.hour
      occurrence3 = create :schedule_occurrence, starts_at: t + 1.day
      occurrence4 = create :schedule_occurrence, starts_at: t - 1.day

      ScheduleOccurrence.between(t - 1.hour, t + 2.hours).should eq [occurrence1, occurrence2]
    end

    it "can grab stuff that started before the start time or ends after the end time" do
      t = Time.new(2013, 6, 1)

      occurrence1 = create :schedule_occurrence, starts_at: t - 2.hours, ends_at: t + 1.hour
      occurrence2 = create :schedule_occurrence, starts_at: t + 6.hours, ends_at: t + 9.hours

      ScheduleOccurrence.between(t, t + 8.hours).should eq [occurrence1, occurrence2]
    end
  end

  describe '::current' do
    it "gets the currently occurrences" do
      occurrence_yesterday = create :schedule_occurrence, starts_at: Time.now.yesterday
      occurrence_tomorrow  = create :schedule_occurrence, starts_at: Time.now.tomorrow
      occurrence_now       = create :schedule_occurrence, starts_at: Time.now - 1.minute

      ScheduleOccurrence.current.should eq [occurrence_now] 
    end
  end

  describe '::at' do
    it "gets occurrences happening at the requested time" do
      occurrence_yesterday = create :schedule_occurrence, starts_at: Time.now.yesterday - 1.minute
      occurrence_tomorrow  = create :schedule_occurrence, starts_at: Time.now.tomorrow
      occurrence_now       = create :schedule_occurrence, starts_at: Time.now

      ScheduleOccurrence.at(Time.now.yesterday).should eq [occurrence_yesterday]
    end
  end

  describe "::on_at" do
    it "selects the first distinct slot if it's present" do
      occurrence = create :schedule_occurrence
      ScheduleOccurrence.on_at(occurrence.starts_at).should eq occurrence
    end

    it "gets the first recurring slot if no distinct slots are present" do
      # We have to do it this round-about way because the
      # rule will be saved before its ID was set on the occurrence,
      # and the rule's "build_occurrences" callback was getting triggered.
      occurrence  = create :schedule_occurrence
      rule        = build :recurring_schedule_rule
      rule.schedule_occurrences << occurrence
      rule.save!

      ScheduleOccurrence.on_at(occurrence.starts_at).should eq occurrence 
    end
  end

  describe '::block' do
    it "returns a single stream of events between the requested dates" do
      t = Time.new(2013, 6, 1)

      occurrence1 = create :schedule_occurrence, starts_at: t
      occurrence2 = create :schedule_occurrence, starts_at: t + 1.hour
      occurrence3 = create :schedule_occurrence, starts_at: t + 1.day
      occurrence4 = create :schedule_occurrence, starts_at: t - 1.day

      ScheduleOccurrence.block(t-1.hour, 3.hours).should eq [occurrence1, occurrence2]
    end

    it "gets rid of occurences which happen inside of another" do
      t = Time.new(2013, 6, 1)

      occurrence1 = create :schedule_occurrence, starts_at: t
      occurrence2 = create :schedule_occurrence, starts_at: t - 1.hour, ends_at: t + 1.hour

      ScheduleOccurrence.block(t-1.hour, 3.hours).should eq [occurrence2]
    end
  end


  describe '#following_occurrence' do
    it "selects the slot immediately following this one" do
      t = Time.new(2013, 6, 1)
      Time.stub(:now) { t + 20.minutes }

      occurrence1 = create :schedule_occurrence, starts_at: t, ends_at: t + 2.hour
      occurrence2 = create :schedule_occurrence, starts_at: t + 30.minutes, ends_at: t + 1.hour

      occurrence1.following_occurrence.should eq occurrence2
      occurrence2.following_occurrence.should eq occurrence1
    end
  end

  describe 'detachment from recurring rule' do
    it "takes place when a recurring occurrence's dates change" do
      occurrence = create :schedule_occurrence, :recurring
      occurrence.recurring_schedule_rule.should be_present

      occurrence.starts_at = Time.now.tomorrow
      occurrence.save!

      occurrence.recurring_schedule_rule.should eq nil
    end
  end

  #------------

  describe "#listen_live_json" do
    it "is a thing, which does stuff" do
      occurrence = create :schedule_occurrence
      occurrence.listen_live_json
    end
  end
end
