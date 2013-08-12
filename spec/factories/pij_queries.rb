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
    status PijQuery::STATUS_LIVE

    trait :featured do
      is_featured true
    end

    trait :published do
      status PijQuery::STATUS_LIVE
    end

    trait :pending do
      status PijQuery::STATUS_PENDING
    end
  end
end
