##
# Homepages
#
FactoryGirl.define do
  factory :homepage do
    base "default"
    sequence(:published_at) { |n| Time.now + 60*60*n }
    status Homepage::STATUS_LIVE

    trait :pending do
      status Homepage::STATUS_PENDING
    end

    trait :published do
      status Homepage::STATUS_LIVE
      published_at { 2.hours.ago }
    end
  end
  
  #-----------------------
  
  factory :homepage_content do
    homepage
    content { |hc| hc.association(:content_shell) }
  end
end
