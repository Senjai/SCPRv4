##
# Schedule
#
FactoryGirl.define do
  factory :recurring_schedule_rule do
    schedule {
      t = Time.new(2013, 7, 1) # 5 mondays in this month

      IceCube::Schedule.new { |s| 
        s.rrule(IceCube::Rule.weekly
          .day(t.day).hour_of_day(t.hour)
        )
      }
    }

    program { |f| f.association :kpcc_program }
  end

  #--------------------

  factory :schedule_occurrence do
    title "Cool Event"
    info_url "http://scpr.org"

    sequence(:starts_at) { |n| Time.now + n.hours }
    ends_at { starts_at + 1.hour }

    trait :recurring do
      recurring_schedule_rule
    end
  end
end
