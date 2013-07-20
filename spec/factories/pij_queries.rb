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
    status 5

    trait :featured do
      is_featured true
    end
  end
end
