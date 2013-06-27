##
# PIJ Queries
#
FactoryGirl.define do
  factory :pij_query do
    sequence(:headline) { |n| "PIJ Query ##{n}"}
    teaser "This a teaser"
    body { "Body: #{teaser}" }
    slug { headline.parameterize }  
    query_type "news"
    pin_query_id '01aa97973688'

    trait :utility do
      query_type "utility"
    end

    trait :evergreen do
      query_type "evergreen"
    end

    trait :news do
      query_type "news"
    end

    trait :featured do
      is_featured true
    end

    trait :visible do
      is_active true
      published_at  { 1.day.ago }
    end

    trait :inactive do
      is_active     false
      published_at  { 1.day.ago }
    end

    trait :unpublished do
      is_active     true
      published_at  { 1.day.from_now }
    end
  end
end
