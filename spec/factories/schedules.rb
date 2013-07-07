##
# Schedule
#
FactoryGirl.define do
  factory :recurring_schedule_rule do
    interval 1
    days [1, 2, 3, 4]
    start_time "11:00"
    end_time "13:00"

    program { |f| f.association :kpcc_program }
  end

  #--------------------

  factory :schedule_occurrence do
    event_title "Cool Event"
    info_url "http://scpr.org"

    sequence(:starts_at) { |n| Time.now + n.hours }
    ends_at { starts_at + 1.hour }

    trait :recurring do
      recurring_schedule_rule
    end
  end
end
