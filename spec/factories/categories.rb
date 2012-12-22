##
# Categories
#
FactoryGirl.define do
  factory :category do
    trait :is_news do 
      sequence(:title) { |n| "Local #{n}" }
      is_news true
    end

    trait :is_not_news do
      sequence(:title) { |n| "Culture #{n}" }
      is_news false
    end

    slug { title.parameterize }

    factory :category_news, traits: [:is_news]
    factory :category_not_news, traits: [:is_not_news]
  end
end
