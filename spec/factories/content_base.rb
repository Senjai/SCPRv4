FactoryGirl.define do
  trait :pending do
    status 3
  end
  
  trait :published do
    status 5
    sequence(:published_at) { |n| Time.now - n.hours }
  end
  
  trait :draft do
    status 0
  end
end
