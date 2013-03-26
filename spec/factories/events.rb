##
# Event
#
FactoryGirl.define do
  factory :event do
    sequence(:headline)   { |n| "A Very Special Event #{n}" }
    sequence(:starts_at)  { |n| Time.now + 60*60*24*n }

    slug                { headline.parameterize }
    body                "This is a very special event."
    event_type          "comm"
    status 0

    trait :published do
      status 5
    end

    trait :with_address do
      address_1 "123 Fake St."
      address_2 "Apt. A"
      city      "Pasadena"
      state     "CA"
      zip_code  "12345"
    end

    trait :multiple_days_past do
      starts_at { 3.days.ago }
      ends_at   { 1.day.ago }
    end

    trait :multiple_days_current do
      starts_at { 1.day.ago }
      ends_at   { 1.day.from_now }
    end

    trait :multiple_days_future do
      starts_at { 1.day.from_now }
      ends_at   { 3.days.from_now }
    end

    trait :past do
      starts_at { 3.hours.ago }
      ends_at   { 2.hours.ago }
    end

    trait :current do
      sequence(:starts_at) { |n| n.hours.ago }
      sequence(:ends_at)   { |n| n.hours.from_now }
    end

    trait :future do
      starts_at { 2.hours.from_now }
      ends_at   { 3.hours.from_now }
    end
  end
end
