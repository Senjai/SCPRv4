require 'spec_helper'

describe Job::BuildRecurringSchedule do
  it "creates occurrences for next month" do
    rule = create :recurring_schedule_rule
    rule.schedule_occurrences.destroy_all
    rule.schedule_occurrences(true).should be_blank

    Job::BuildRecurringSchedule.perform

    next_month = Time.now.next_month

    rule.schedule_occurrences
    .between(next_month.beginning_of_month, next_month.end_of_month)
    .should be_present

    rule.schedule_occurrences.before(next_month.beginning_of_month).should be_blank
    rule.schedule_occurrences.after(next_month.end_of_month).should be_blank
  end
end
