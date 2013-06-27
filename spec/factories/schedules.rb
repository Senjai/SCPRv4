##
# Schedule
#
FactoryGirl.define do
  factory :recurring_schedule_slot do
    sequence(:start_time) { |n| (Time.now + n.hours).second_of_week }
    end_time { start_time + 1.hour }
    program { |f| f.association :kpcc_program }
  end

  #--------------------

  factory :distinct_schedule_slot do
    title "Cool Event"
    sequence(:starts_at) { |n| Time.now + n.hours }
    ends_at { starts_at + 1.hour }
  end
end
