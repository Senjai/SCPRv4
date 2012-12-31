##
# Homepages
#
FactoryGirl.define do
  factory :homepage do
    base "default"
    sequence(:published_at) { |n| Time.now + 60*60*n }
    status 5

    trait :published do
      status 5
      published_at { 2.hours.ago }
    end
  end
  
  #-----------------------
  
  factory :homepage_content do
    homepage
    content { |hc| hc.association(:content_shell) }
  end
end
