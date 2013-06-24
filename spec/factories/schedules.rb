##
# Schedule
#
FactoryGirl.define do
  factory :recurring_schedule_slot do
    sequence(:start_time) { |n| Time.new(2012, 10, 25, 1*n).second_of_week }
    end_time { start_time + 2.hours }
    program { |f| f.association :kpcc_program }
  end

  #--------------------

  factory :distinct_schedule_slot do
    title "Cool Event"
    sequence(:starts_at) { |n| Time.now + n.hours }
    ends_at { starts_at + 1.hour }
  end
end
