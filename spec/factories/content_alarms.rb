##
# Content Alarms
#
FactoryGirl.define do
  factory :content_alarm do
    content { |alarm| alarm.association :news_story, :pending }
    
    trait :pending do
      fire_at { Time.now - 2.hours }
    end
    
    trait :future do
      fire_at { Time.now + 2.hours }
    end
  end
end
